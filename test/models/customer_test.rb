require "test_helper"

describe Customer do
  let(:customer) { Customer.new(name: "Shelley Rocha",
  registered_at: DateTime.new(2015, 4, 29),
  address: "Ap #292-5216 Ipsum Rd.",
  city: "Hillsboro",
  state: "OR",
  postal_code: "24309",
  phone: "(322) 510-8695") }

  it "must be valid" do
    value(customer).must_be :valid?
  end

  it "must be invalid with missing name" do
    customer.name = nil
    value(customer).wont_be :valid?
  end

  it "must be invalid with missing registered_at" do
    customer.registered_at = nil
    value(customer).wont_be :valid?
  end

  it "must be invalid with missing address" do
    customer.address = nil
    value(customer).wont_be :valid?
  end

  it "must be invalid with missing city" do
    customer.city = nil
    value(customer).wont_be :valid?
  end

  it "must be invalid with missing state" do
    customer.state = nil
    value(customer).wont_be :valid?
  end

  it "must be invalid with missing postal_code" do
    customer.postal_code = nil
    value(customer).wont_be :valid?
  end

  it "must be invalid with missing phone" do
    customer.phone = nil
    value(customer).wont_be :valid?
  end

end
