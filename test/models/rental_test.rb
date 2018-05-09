require "test_helper"

describe Rental do
  let(:rental) { rentals(:one) }
  let(:invalid_rental) { Rental.new(
    checkout_date: Date.new(2018,05,8),
    due_date: Date.new(2018,05,15),
    returned: false,
    customer: customers(:lyn),
    movie: movies(:robots)
    )
  }

  describe "validity" do
    it "must be valid" do
      value(rental).must_be :valid?
      rental.must_respond_to :movie
      rental.movie.must_be_kind_of Movie
      rental.must_respond_to :customer
      rental.customer.must_be_kind_of Customer
      rental.must_respond_to :returned
      rental.must_respond_to :checkout_date
      rental.checkout_date.must_be_kind_of Date
      rental.must_respond_to :due_date
      rental.due_date.must_be_kind_of Date
    end

    it "invalid without a movie" do
      invalid_rental.movie = nil

      value(invalid_rental).wont_be :valid?
    end

    it "invalid without a customer" do
      invalid_rental.customer = nil

      value(invalid_rental).wont_be :valid?
    end

    it "invalid without a returned status" do
      invalid_rental.returned = nil

      value(invalid_rental).wont_be :valid?
    end

    it "invalid without a checkout date" do
      invalid_rental.checkout_date = nil

      value(invalid_rental).wont_be :valid?
    end

    it "wont be valid for a non-date checkout date" do
      invalid_rental.checkout_date = "string"

      value(invalid_rental).wont_be :valid?
    end

    it "invalid without a due date" do
      invalid_rental.due_date = nil

      value(invalid_rental).wont_be :valid?
    end

    it "wont be valid for a non-boolean due date" do
      invalid_rental.due_date = "string"

      value(invalid_rental).wont_be :valid?
    end
  end

  describe "relationships" do
    it "has one movie" do
      rental.customer.id.must_equal customers(:curr).id
    end

    it "has one customer" do
      rental.movie.id.must_equal movies(:savior).id
    end
  end
end
