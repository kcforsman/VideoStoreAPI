class RentalsController < ApplicationController
  def check_out
    customer = Customer.find_by(id: params[:customer_id])

    movie = Movie.find_by(id: params[:movie_id])

    Rental.create(customer: customer, movie: movie, checkout_date: Date.today, due_date: Date.today + 7.days)

    render json: { status: 200}
  end

  def check_in

  end
end
