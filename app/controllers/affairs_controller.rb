# frozen_string_literal: true

class AffairsController < ApplicationController
  def index
    @affairs = Affair.paginate(page: params[:page], per_page: 10)
    @affairs = Affair.paginate(page: params[:page], per_page: 10)
    @affairs = Affair.paginate(page: params[:page], per_page: 10)
    @affairs = Affair.paginate(page: params[:page], per_page: 10)
    @affairs = Affair.paginate(page: params[:page], per_page: 10)
    @affairs = Affair.paginate(page: params[:page], per_page: 10)
    @affairs = Affair.paginate(page: params[:page], per_page: 10)
    @affairs = Affair.paginate(page: params[:page], per_page: 10)
    @affairs = Affair.paginate(page: params[:page], per_page: 10)
    @affairs = Affair.paginate(page: params[:page], per_page: 10)
    @affairs = Affair.paginate(page: params[:page], per_page: 10)
    @affairs = Affair.paginate(page: params[:page], per_page: 10)
    @affairs = Affair.paginate(page: params[:page], per_page: 10)
    @affairs = Affair.paginate(page: params[:page], per_page: 10)
    @affairs = Affair.paginate(page: params[:page], per_page: 10)
  end

  def show
    @affair = Affair.find(params[:id])
  end

  def new
    @affair = Affair.new
    @affair.assignments.new
  end

  def edit
    @affair = Affair.find(params[:id])
  end

  def create
    @affair = Affair.new(affair_params)
    if @affair.save
      redirect_to @affair
      flash[:notice] = 'Affair successfully created'
    else
      render 'new'
      flash[:alert] = 'Affair could not be created'
    end
  end

  def update
    @affair = Affair.find(params[:id])
    if @affair.update(affair_params)
      redirect_to @affair
      flash[:notice] = 'Affair successfully created'
    else
      render 'edit'
      flash[:alert] = 'Affair could not be created'
    end
  end

  def destroy
    @affair = Affair.find(params[:id])
    if @affair.destroy
      redirect_to affairs_path
      flash[:error] = 'Affair successfully destroyed'
    else
      render 'index'
      flash[:alert] = 'Affair could not be destroyed'
    end
  end

  private

  def affair_params
    params.require(:affair)
          .permit(:file_number,
                  :client_id,
                  :start_date,
                  :finish_date,
                  :status,
                  assignments_attributes: %i[id affair_id attorney_id _destroy])
  end
end
