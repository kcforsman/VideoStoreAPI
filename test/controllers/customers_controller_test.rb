require "test_helper"

describe CustomersController do
  describe "index" do
    it "is a real working route" do
      get customers_url

      must_respond_with :success
    end

    it "return json" do
      get customers_url

      response.header['Content-Type'].must_include "json"
    end

    it "returns an Array of all Customers" do
      get customers_url

      body = JSON.parse(response.body)
      body.must_be_kind_of Array
      body.length.must_equal Customer.count
    end

    it "returns customers with exactly the required fields" do
      keys = %w(id movies_checked_out_count name phone postal_code registered_at)
      get customers_url

      body = JSON.parse(response.body)
      body.each do |customer|
        customer.keys.sort.must_equal keys
      end
    end

    it "returns an empty Array if there are no customers" do
      Customer.all.each do |customer|
        customer.rentals.each {|rental| rental.destroy}
        customer.destroy
      end

      get customers_url

      body = JSON.parse(response.body)
      body.must_be :empty?
    end
  end

end
