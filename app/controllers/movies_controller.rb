class MoviesController < ApplicationController
  def index
    movies = Movie.all

    render json: movies.as_json(only: [:id, :title, :release_date])
  end

  def show
    movie = Movie.find_by(id: params[:id])
    if movie
      render json: movie.as_json(only: [:inventory, :overview, :release_date, :title, :available_inventory])
    else
      render json: {ok: false, errors: "Movie not found"}, status: :not_found
    end
  end

  def create
  end
end
