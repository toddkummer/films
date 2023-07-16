# frozen_string_literal: true

class FilmsController < ApplicationController
  before_action :set_film, only: %i[show edit update destroy]

  # GET /films
  def index
    @films = Film.all
  end

  # GET /films/1
  def show; end

  # GET /films/new
  def new
    @film = Film.new
  end

  # GET /films/1/edit
  def edit; end

  # POST /films
  def create
    @film = Film.new(film_params)

    if @film.save
      redirect_to @film, notice: 'Film was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /films/1
  def update
    if @film.update(film_params)
      redirect_to @film, notice: 'Film was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /films/1
  def destroy
    @film.destroy
    redirect_to films_url, notice: 'Film was successfully destroyed.', status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_film
    @film = Film.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def film_params
    params.require(:film).permit(:name, :release_year, :production_company_id, :distributor_id)
  end
end
