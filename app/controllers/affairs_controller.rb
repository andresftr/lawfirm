class AffairsController < ApplicationController
  def index
    @affairs = Affair.all
  end

  def show
    @affair = Affair.find(params[:id])
  end

  def new
    @affair = Affair.new
  end

  def edit
    @affair = Affair.find(params[:id])
  end

  def create
    @affair = Affair.new(affair_params)

    if @affair.save
      redirect_to @affair
    else
      render 'new'
    end
  end

  def update
    @affair = Affair.find(params[:id])

    if @affair.update(affair_params)
      redirect_to @affair
    else
      render 'edit'
    end
  end

  def destroy
    @affair = Affair.find(params[:id])
    @affair.destroy

    redirect_to affairs_path
  end

  private
    def affair_params
      params.require(:affair).permit(:file_number, :client_id, :start_date, :finish_date, :status)
    end
end
