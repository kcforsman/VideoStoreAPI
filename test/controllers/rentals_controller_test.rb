require "test_helper"

describe RentalsController do
  let(:customer) {customers(:shell)}
  let(:movie) {movies(:women)}

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
    end
  end
  it "should get check-in" do
    skip
    get rentals_check-in_url
    value(response).must_be :success?
  end

end
