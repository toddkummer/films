# frozen_string_literal: true

class LocationsController < ApplicationController
  before_action :build_filtered_query, only: :index
  before_action :set_location, only: %i[show edit update destroy]

  filter :name, partial: true

  # GET /locations
  def index
    respond_to do |format|
      format.html
      format.json { render json: @locations.limit(page_limit), only: %i[id name] }
    end
  end

  # GET /locations/1
  def show; end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit; end

  # POST /locations
  def create
    @location = Location.new(location_params)

    if @location.save
      redirect_to @location, notice: 'Location was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /locations/1
  def update
    if @location.update(location_params)
      redirect_to @location, notice: 'Location was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /locations/1
  def destroy
    @location.destroy
    redirect_to locations_url, notice: 'Location was successfully destroyed.', status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_location
    @location = Location.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def location_params
    params.require(:location).permit(:name, :find_neighborhood_id, :analysis_neighborhood_id, :supervisor_district_id)
  end
end
