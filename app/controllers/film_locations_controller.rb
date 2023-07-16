# frozen_string_literal: true

class FilmLocationsController < ApplicationController
  before_action :set_film_location, only: %i[show edit update destroy]

  # GET /film_locations
  def index
    @film_locations = FilmLocation.all
  end

  # GET /film_locations/1
  def show; end

  # GET /film_locations/new
  def new
    @film_location = FilmLocation.new
  end

  # GET /film_locations/1/edit
  def edit; end

  # POST /film_locations
  def create
    @film_location = FilmLocation.new(film_location_params)

    if @film_location.save
      redirect_to @film_location, notice: 'Film location was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /film_locations/1
  def update
    if @film_location.update(film_location_params)
      redirect_to @film_location, notice: 'Film location was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /film_locations/1
  def destroy
    @film_location.destroy
    redirect_to film_locations_url, notice: 'Film location was successfully destroyed.', status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_film_location
    @film_location = FilmLocation.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def film_location_params
    params.require(:film_location).permit(:film_id, :location_id, :fun_facts)
  end
end
