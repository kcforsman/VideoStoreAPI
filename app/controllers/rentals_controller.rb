class RentalsController < ApplicationController
  def check_out
    customer = Customer.find_by(id: params[:customer_id])

    movie = Movie.find_by(id: params[:movie_id])

    if customer && movie
      if movie.available_inventory > 0
        rental = Rental.new(customer: customer, movie: movie, checkout_date: Date.today, due_date: Date.today + 7.days)
        customer.movies_checked_out_count += 1
        movie.available_inventory -= 1
        if rental.save && movie.save && customer.save
          render json: { status: 200}
        else
          render json: { ok: false, errors: rental.errors}, status: :bad_request
        end
      else
        render json: { ok: false, errors: "Sorry, not enough inventory"}, status: 404
      end
    else
      render json: { ok: false, errors: "Invalid movie or customer"}, status: 404
    end
  end

  def check_in
    customer = Customer.find_by(id: params[:customer_id])
    movie = Movie.find_by(id: params[:movie_id])
    if customer && movie
      rental = Rental.find_by(customer: customer, movie: movie, returned: false)
      if rental
        rental.returned = true
        customer.movies_checked_out_count -= 1
        movie.available_inventory += 1
        if rental.save && movie.save && customer.save
          render json: { status: 200}
        else
          render json: { ok: false, errors: "Something went wrong."}, status: :bad_request
        end
      else
        render json: { ok: false, errors: "Invalid rental"}, status: 404
      end
    else
      render json: { ok: false, errors: "Invalid movie or customer"}, status: 404
    end
  end

  def overdue
    overdue_rentals = []
    Rental.where(returned: false).each do |rental|
      overdue_rentals << rental if rental.due_date < Date.today
    end
     overdue_attributes = []
    if overdue_rentals.empty?
      render json: { overdue: false, errors: "No overdue rentals at this time"}, status: :not_found
    else
      overdue_rentals.each do |overdue_rental|
        overdue_attributes << {
          checkout_date: overdue_rental.checkout_date,
          due_date: overdue_rental.due_date,
          customer_id: overdue_rental.customer_id,
          name: overdue_rental.customer.name,
          postal_code: overdue_rental.customer.postal_code,
          movie_id: overdue_rental.movie_id,
          title: overdue_rental.movie.title
        }
      end
      render json: overdue_attributes
    end
  end
end
