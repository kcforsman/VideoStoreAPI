require "test_helper"

describe RentalsController do
  let(:customer) {customers(:shell)}
  let(:customer2) {customers(:curr)}
  let(:movie) {movies(:women)}
  let(:movie2) {movies(:savior)}

  describe 'check_out' do
    it "should get check-out" do
      post check_out_url, params: { customer_id: customer.id, movie_id: movie.id }
      value(response).must_be :success?
    end

    it "should render status not_found for invalid customer " do
      id = customer.id
      customer.rentals.each {|rental| rental.destroy}
      customer.destroy
      post check_out_url, params: { customer_id: id, movie_id: movie.id }
      value(response).must_be :not_found?
    end

    it "should render status not_found for invalid movie " do
      id = movie.id
      movie.destroy
      post check_out_url, params: { customer_id: customer.id, movie_id: id }

      value(response).must_be :not_found?
      body = JSON.parse(response.body)
      body.must_include "ok"
      body["ok"].must_equal false
      body.must_include "errors"
      body["errors"].must_equal "Invalid movie or customer"
    end
  end

  describe "check-in" do
    it "should get check-in" do
      post check_in_url, params: { customer_id: customer2.id, movie_id: movie2.id }

      value(response).must_be :success?
    end

    it "check-in should change returned status to true" do
      rental = rentals(:one)

      post check_in_url, params: { customer_id: customer2.id, movie_id: movie2.id }

      rental = Rental.find_by(id: rental.id)
      rental.returned.must_equal true
    end

    it "should render status not_found for invalid customer " do
      id = customer.id
      customer.rentals.each {|rental| rental.destroy}
      customer.destroy
      post check_in_url, params: { customer_id: id, movie_id: movie2.id }
      value(response).must_be :not_found?
    end

    it "should render status not_found for invalid movie " do
      id = movie.id
      movie.destroy
      post check_in_url, params: { customer_id: customer2.id, movie_id: id }

      value(response).must_be :not_found?
      body = JSON.parse(response.body)
      body.must_include "ok"
      body["ok"].must_equal false
      body.must_include "errors"
      body["errors"].must_equal "Invalid movie or customer"
    end

    it "should render status not_found for rental that DNE" do
      post check_in_url, params: { customer_id: customer.id, movie_id: movie.id }

      value(response).must_be :not_found?
      body = JSON.parse(response.body)
      body.must_include "ok"
      body["ok"].must_equal false
      body.must_include "errors"
      body["errors"].must_equal "Invalid rental"
    end

    it "should render status not_found for rental with true returned status" do
      post check_in_url, params: { customer_id: customer2.id, movie_id: movies(:blacksmith).id }

      value(response).must_be :not_found?
      body = JSON.parse(response.body)
      body.must_include "ok"
      body["ok"].must_equal false
      body.must_include "errors"
      body["errors"].must_equal "Invalid rental"
    end
  end

  describe "Overdue" do
    it "can generate list of overdue rentals " do
      get overdue_url

      body = JSON.parse(response.body)
      body.must_be_kind_of Array
      must_respond_with :success
      body.length.must_equal 1
    end

    it "returns movies with exactly the required fields" do
      # must be listed in alphabetical order
      keys = %w(checkout_date customer_id due_date movie_id name postal_code title)
      get movies_url
      body = JSON.parse(response.body)
      body.each do |rental|
        rental.keys.sort.must_equal keys
      end
    end
  end
end
