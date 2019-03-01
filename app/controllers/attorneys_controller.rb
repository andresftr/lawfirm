class AttorneysController < ApplicationController
  def index
    @attorneys = Attorney.all
  end

  def show
    @attorney = Attorney.find(params[:id])
  end

  def new
    @attorney = Attorney.new
  end

  def edit
    @attorney = Attorney.find(params[:id])
  end

  def create
    @attorney = Attorney.new(attorney_params)

    if @attorney.save
      redirect_to @attorney
    else
      render 'new'
    end
  end

  def update
    @attorney = Attorney.find(params[:id])

    if @attorney.update(attorney_params)
      redirect_to @attorney
    else
      render 'edit'
    end
  end

  def destroy
    @attorney = Attorney.find(params[:id])
    @attorney.destroy

    redirect_to attorneys_path
  end

  private
    def attorney_params
      params.require(:attorney).permit(:dni, :full_name, :address, :nacionality)
    end
end
