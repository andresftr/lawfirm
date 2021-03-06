# frozen_string_literal: true

# Assignment controller with the crud actions
class AssignmentsController < ApplicationController
  def index
    @assignments = Assignment.paginate(page: params[:page], per_page: 10)
  end

  def show
    @assignment = Assignment.find(params[:id])
  end

  def new
    @assignment = Assignment.new
  end

  def edit
    @assignment = Assignment.find(params[:id])
  end

  def create
    @assignment = Assignment.new(assignment_params)
    if @assignment.save
      redirect_to @assignment
      flash[:notice] = 'Assignment successfully created'
    else
      render 'new'
      flash[:alert] = 'Assignment could not be created'
    end
  end

  def update
    @assignment = Assignment.find(params[:id])
    if @assignment.update(assignment_params)
      redirect_to @assignment
      flash[:notice] = 'Assignment successfully created'
    else
      render 'edit'
      flash[:alert] = 'Assignment could not be created'
    end
  end

  def destroy
    @assignment = Assignment.find(params[:id])
    if @assignment.destroy
      redirect_to assignments_path
      flash[:error] = 'Assignment successfully destroyed'
    else
      render 'index'
      flash[:alert] = 'Assignment could not be destroyed'
    end
  end

  private

  def assignment_params
    params.require(:assignment).permit(:affair_id, :attorney_id)
  end
end
