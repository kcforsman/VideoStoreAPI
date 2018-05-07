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

    it "returns an Array of all the movies" do
      get movies_url

      body = JSON.parse(response.body)
      body.must_be_kind_of Array
      body.length.must_equal Movie.count
    end

    it "returns movies with exactly the required fields" do
      # must be listed in alphabetical order
      keys = %w(id release_date title)
      get movies_url
      body = JSON.parse(response.body)
      body.each do |movie|
        movie.keys.sort.must_equal keys
      end
    end

    it "returns [] when there are no movies" do
      Movie.delete_all

      get movies_url

      body = JSON.parse(response.body)
      body.must_be :empty?

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
