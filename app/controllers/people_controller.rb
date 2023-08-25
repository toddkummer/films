# frozen_string_literal: true

class PeopleController < ApplicationController
  before_action :set_person, only: %i[show edit update destroy]

  # GET /people
  def index
    @people = Person.all
    apply_optional_criteria

    respond_to do |format|
      format.html
      format.json { render json: @people.limit(5), only: %i[id name] }
    end
  end

  # GET /people/1
  def show; end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit; end

  # POST /people
  def create
    @person = Person.new(person_params)

    if @person.save
      redirect_to @person, notice: 'Person was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /people/1
  def update
    if @person.update(person_params)
      redirect_to @person, notice: 'Person was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /people/1
  def destroy
    @person.destroy
    redirect_to people_url, notice: 'Person was successfully destroyed.', status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_person
    @person = Person.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def person_params
    params.require(:person).permit(:name)
  end

  def apply_optional_criteria
    @people = @people.where('name like ?', "%#{Person.sanitize_sql_like(params[:name])}%") if params.key?(:name)
    @people = @people.director if params[:director]
    @people = @people.writer if params[:writer]
    @people = @people.actor if params[:actor]
  end
end
