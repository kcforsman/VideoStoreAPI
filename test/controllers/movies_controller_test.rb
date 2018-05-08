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

  describe "show" do
    let(:movie) { movies(:savior) }
    it "is a real working route to index" do
      get movie_url(movie.id)

      value(response).must_be :success?
      response.header['Content-Type'].must_include 'json'
      body = JSON.parse(response.body)
      body.must_be_kind_of Hash
    end

    it "returns movie with exactly the required fields" do
      # must be listed in alphabetical order
      keys = %w(available_inventory inventory overview release_date title)
      get movie_url(movie.id)
      movie = JSON.parse(response.body)
      movie.keys.sort.must_equal keys
    end

    it "returns not_found for invalid id and returns error in body" do
      id = movie.id
      movie.destroy

      get movie_url(id)

      value(response).must_be :not_found?
      body = JSON.parse(response.body)
      body.must_be_kind_of Hash
      body.must_include "ok"
      body["ok"].must_equal false
      body.must_include "errors"
      body["errors"].must_equal "Movie not found"
    end
  end

  describe "create" do
    let(:movie_data) {
      {
        title: "The Princess Bride",
        release_date: Date.new(2010,11,05),
        inventory: 5,
        available_inventory: 3
      }
    }

    it "should get create" do
      get movies_path
      value(response).must_be :success?
    end

    it "Creates a new movie" do

      proc {
        post movies_path, params: {movie: movie_data}
      }.must_change 'Movie.count', 1

      must_respond_with :success

      body = JSON.parse(response.body)
      body.must_be_kind_of Hash
      body.must_include "id"

      # Check that the ID matches
      Movie.find(body["id"]).title.must_equal movie_data[:title]
    end

    it "returns a bad_request for bad params data" do
      not_a_movie ={
        release_date: Date.new(2010,11,05),
        inventory: 5,
        available_inventory: 3
      }
      proc {
        post movies_path, params: {movie: not_a_movie}
      }.wont_change 'Movie.count'

      must_respond_with :bad_request

      body = JSON.parse(response.body)
      body.must_be_kind_of Hash
      body.must_include "ok"
      body["ok"].must_equal false
      body.must_include "errors"
      body["errors"].must_include "title"

    end
  end
end
