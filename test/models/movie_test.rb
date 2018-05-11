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

  describe 'relations' do
    it "should have many rentals" do
      movie = movies(:blacksmith)

      movie.must_respond_to :rentals
      movie.rentals.count.must_equal 2
      movie.rentals.first.must_be_instance_of Rental
    end

    it "responds to movies with no rentals" do
      movie = movies(:women)

      movie.rentals.count.must_equal 0
    end

    it "can get assigned new rentals" do
        movie = movies(:blacksmith)
        customer = customers(:shell)
      Rental.create({
        movie_id: movie.id,
        customer_id: customer.id
        })

        movie.rentals.count.must_equal 2
      end
  end

end
