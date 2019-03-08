class AttorneysController < ApplicationController
  def index
    @attorneys = Attorney.all
  end

  def show
    @attorney = Attorney.find(params[:id])
  end

  def new
    @attorney = Attorney.new
    @attorney.assignments.new
  end

  def edit
    @attorney = Attorney.find(params[:id])
  end

  def create
    @attorney = Attorney.new(attorney_params)

    if @attorney.save
      redirect_to @attorney
      flash[:notice] = "Attorney successfully created"
    else
      render 'new'
      flash[:alert] = "Attorney could not be created"
    end
  end

  def update
    @attorney = Attorney.find(params[:id])

    if @attorney.update(attorney_params)
      redirect_to @attorney
      flash[:notice] = "Attorney successfully created"
    else
      render 'edit'
      flash[:alert] = "Attorney could not be created"
    end
  end

  def destroy
    @attorney = Attorney.find(params[:id])
    
    if @attorney.destroy
      redirect_to attorneys_path
      flash[:error] = "Attorney successfully destroyed"
    else
      render 'index'
      flash[:alert] = "Attorney could not be destroyed"
    end
  end

  private
    def attorney_params
      params.require(:attorney).permit(
        :dni, :full_name, :address, :nacionality,
        assignments_attributes: [ :id, :affair_id, :attorney_id, :_destroy ]
        )
    end
end
