require "test_helper"

describe MoviesController do
  describe "index" do
    it "is a real working route to index" do
      get movies_url
      must_respond_with :success
    end
    it "returns json" do
      get movies_url
      response.header['Content-Type'].must_include 'json'
    end
  end


  it "should get show" do
    get movies_show_url
    value(response).must_be :success?
  end

  it "should get create" do
    get movies_create_url
    value(response).must_be :success?
  end

end
