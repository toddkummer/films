# frozen_string_literal: true

class FilmsController < ApplicationController
  before_action :set_film, only: %i[show edit update destroy]

  filter :name, partial: true
  filter :location_id, association: :film_locations
  filter :director_id, name: :directed_by
  filter :writer_id, name: :written_by
  filter :actor_id, name: :acted_by

  sort :release_year
  default_sort release_year: :asc

  layout false, only: %i[show index]

  EAGER_LOADS_FOR_INDEX = [:production_company, :distributor, :poster,
                           { film_locations: :location,
                             directing_credits: :person,
                             acting_credits: :person,
                             writing_credits: :person }].freeze

  # GET /films
  def index
    @films = build_query_from_filters(Film.includes(EAGER_LOADS_FOR_INDEX))
    @films = paginate_resource(@films, default_limit: 12)

    respond_to do |format|
      format.html do
        render phlex(@films, filter_chips: build_filter_chips,
                             query_params: build_pagination_query_params,
                             sort: params.dig(:filter, :sort) || 'release_year')
      end
      format.json { render json: @films, only: %i[id name release_year] }
    end
  end

  # GET /films/1
  def show
    render phlex(@film)
  end

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
