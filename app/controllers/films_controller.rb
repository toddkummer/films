# frozen_string_literal: true

class FilmsController < ApplicationController
  before_action :set_film, only: %i[show edit update destroy]

  # GET /films
  def index
    @films = Film.includes(:production_company, :distributor,
                           film_locations: :location,
                           directing_credits: :person,
                           acting_credits: :person,
                           writing_credits: :person).all.limit(10)
    apply_optional_criteria

    respond_to do |format|
      format.html
      format.json { render json: @films, only: %i[id name release_year] }
    end
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

  def apply_optional_criteria # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    @films = @films.where('name like ?', "%#{Film.sanitize_sql_like(params[:name])}%") if params.key?(:name)

    if params.key?(:director_id)
      @films = @films.joins(:directing_credits).merge(DirectingCredit.where(person_id: params[:director_id]))
    end
    if params.key?(:actor_id)
      @films = @films.joins(:acting_credits).merge(ActingCredit.where(person_id: params[:actor_id]))
    end

    if params.key?(:writer_id)
      @films = @films.joins(:writing_credits).merge(WritingCredit.where(person_id: params[:writer_id]))
    end

    return unless params.key?(:location_id)

    @films = @films.joins(:film_locations).merge(FilmLocation.where(location_id: params[:location_id]))
  end
end
