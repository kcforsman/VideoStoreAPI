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

end
