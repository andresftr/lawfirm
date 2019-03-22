# frozen_string_literal: true

# Clients controller with the crud actions
class ClientsController < ApplicationController
  def index
    @clients = Client.paginate(page: params[:page], per_page: 10)
  end

  def show
    @client = Client.find(params[:id])
  end

  def new
    @client = Client.new
  end

  def edit
    @client = Client.find(params[:id])
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      redirect_to @client
      flash[:notice] = 'Client successfully created'
    else
      render 'new'
      flash[:alert] = 'Client could not be created'
    end
  end

  def update
    @client = Client.find(params[:id])

    if @client.update(client_params)
      redirect_to @client
      flash[:notice] = 'Client successfully updated'
    else
      render 'edit'
      flash[:alert] = 'Client could not be updated'
    end
  end

  def destroy
    @client = Client.find(params[:id])

    if @client.destroy
      redirect_to clients_path
      flash[:error] = 'Client successfully destroyed'
    else
      render 'index'
      flash[:alert] = 'Client could not be destroyed'
    end
  end

  private

  def client_params
    params.require(:client)
          .permit(:dni,
                  :full_name,
                  :address,
                  :nacionality,
                  :birthdate)
  end
end
