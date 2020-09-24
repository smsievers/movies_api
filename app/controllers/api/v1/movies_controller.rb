class Api::v1::MoviesController < ApplicationController
    before_action :set_movie, only: [:show, :update, :destroy]
    skip_before_action :authenticate, only: [:index, :show]

    def index
        @movies = Movie.all
         
    end

    def show
        @reviews = Review.where(movid_id: params[:id])
        render json: {movie: @movie, reviews: @reviews}
    end
    
    def create
        @movie = Movie.new(movie_params)
        if movie.save
            render json: @movie, status: created
        else
            render json: @movie.errors, status: :unprocessable_entity
        end
    end

    def update
        if @movie.update(movie_params)
            render json: @movie, status: :ok
        else
            render json: @movie.errors, status: :unprocessable_entity
        end
    end

    def destroy
        @movie.destroy
    end
    
    def get_upload_credentials
        @accesskey = ENV['S3_ACCESS']
        @secretkey = ENV['S3_SECRET']
        render json: {accesskey: @accesskey, secretkey: @secretkey}
    end

    private 
        def set_movie
            @movie = Movie.find(params[:id])
        end

        def movie_params
            params.require(:movie).permit[ :title, :description, :parental_rating, :year, :total_gross, :duration, :image, :cast, :director]
        end 

end
