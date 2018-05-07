require "test_helper"

describe Movie do
  let(:movie) { Movie.new(
    title: "Blacksmith Of The Banished",
    overview: "The unexciting life of a boy will be permanently altered as a strange woman enters his life.",
    release_date: Date.new(2090,05,01),
    inventory: 10
    ) }

  it "must be valid" do
    value(movie).must_be :valid?
  end

  it "must be invalid if title does not exist" do
    movie.title = nil
    value(movie).wont_be :valid?
  end

  it "must be invalid if release_date does not exist" do
    movie.release_date = nil
    value(movie).wont_be :valid?
  end

  it "must be invalid if inventory does not exist" do
    movie.inventory = nil
    value(movie).wont_be :valid?
  end
end
