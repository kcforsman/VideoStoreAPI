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
    movie = Movie.create(title: params["title"], release_date: params["release_date"], inventory: params["inventory"], overview: params["overview"] )

    if movie.valid?
      render json: {id: movie.id}, status: :ok
    else
      render json: {ok: false, errors: movie.errors}, status: :bad_request
    end
  end
end

private

def movies_params
  # tests expect that params should not be nested inside movie
  return params.require(:title, :release_date, :inventory, :overview)
end
