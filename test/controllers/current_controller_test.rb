require "test_helper"

describe CurrentController do
  it "should get index" do
    get current_index_url
    value(response).must_be :success?
  end

end
