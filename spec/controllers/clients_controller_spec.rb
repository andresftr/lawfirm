# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClientsController, type: :controller do
  describe '#index' do
    context 'as an authenticated user' do
      before do
        @user = create(:user)
      end

      it 'responds successfully' do
        sign_in @user
        get :index
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status '200'
        end
      end

      context 'when there is no data' do
        it 'assings clients an empty array' do
          sign_in @user
          get :index
          expect(assigns(:clients)).to be_empty
        end
      end

      context 'when there is data' do
        before do
          @clients = create_list(:client, 10)
        end

        it 'assings clients array' do
          sign_in @user
          get :index
          expect(assigns(:clients).count).to eq 10
        end
      end

      context 'clients pagination' do
        before do
          @clients = create_list(:client, 25)
        end
  
        it 'first page of three shows ten clients' do
          sign_in @user
          get :index
          expect(assigns(:clients).page(1)).to match_array(@clients.first(10))
        end
  
        it 'second page should have ten clients as well' do
          sign_in @user
          get :index
          expect(assigns(:clients).page(2).length).to eq 10
        end
  
        it 'third page shows last five clients' do
          sign_in @user
          get :index
          expect(assigns(:clients).page(3)).to match_array(@clients.last(5))
        end
  
        it 'should be empty if out of bounds' do
          sign_in @user
          get :index
          expect(assigns(:clients).page(4)).to be_empty
        end
      end
    end

    context 'as a guest' do
      it 'returns a 302 response' do
        get :index
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        get :index
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#show' do
    before do
      @user = create(:user)
      @client = create(:client)
    end

    it 'responds successfully' do
      sign_in @user
      get :show, params: { id: @client.id }
      expect(response).to be_successful
    end

    it 'no show with a nonexistent client' do
      sign_in @user
      expect { get :show, params: { id: 50 } }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#new' do
    before do
      @user = create(:user)
    end

    it 'render the new template' do
      sign_in @user
      get :new
      expect(response).to render_template(:new)
    end

    it 'assigns a new client' do
      sign_in @user
      get :new
      expect(assigns(:client)).to be_a_new(Client)
    end
  end

  describe '#edit' do
    before do
      @user = create(:user)
      @client = create(:client)
    end

    it 'render the edit template' do
      sign_in @user
      get :edit, params: { id: @client.id }
      expect(response).to render_template(:edit)
    end

    it 'load client params in edit template' do
      sign_in @user
      get :edit, params: { id: @client.id }
      expect(assigns(:client)).to eq(@client)
    end

    it 'no load with a nonexistent client' do
      sign_in @user
      expect { get :edit, params: { id: 50 } }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#create' do
    context 'as an authenticated user' do
      before do
        @user = create(:user)
      end

      context 'with valid attributes' do
        it 'adds a client' do
          client_params = attributes_for(:client)
          sign_in @user
          expect { post :create, params: { client: client_params } }
            .to change(Client, :count).by(1)
        end
      end
  
      context 'with invalid attributes' do
        it 'does not add a client' do
          client_params = attributes_for(:client, :invalid)
          sign_in @user
          expect { post :create, params: { client: client_params } }
            .to_not change(Client, :count)
        end
      end
    end

    context 'as a guest' do
      it 'returns a 302 response' do
        client_params = attributes_for(:client)
        post :create, params: { client: client_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        client_params = attributes_for(:client)
        post :create, params: { client: client_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#update' do
    context ' as an authenticated user' do
      before do
        @user = create(:user)
        @client = create(:client)
      end
  
      it 'updates a client' do
        client_params = attributes_for(:client, full_name: 'New Client Name')
        sign_in @user
        patch :update, params: { id: @client.id, client: client_params }
        expect(@client.reload.full_name).to eq 'New Client Name'
      end
  
      it 'can not update a client' do
        client_params = attributes_for(:client, :invalid)
        sign_in @user
        patch :update, params: { id: @client.id, client: client_params }
        expect(@client.reload.full_name).to eq @client.full_name
      end
    end

    context 'as a guest' do
      before do
        @client = create(:client)
      end

      it 'returns a 302 response' do
        client_params = attributes_for(:client)
        patch :update, params: { id: @client.id, client: client_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        client_params = attributes_for(:client)
        patch :update, params: { id: @client.id, client: client_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#destroy' do
    context 'as an authenticated user' do
      before do
        @user = create(:user)
        @client = create(:client)
      end
  
      it 'deletes a client' do
        sign_in @user
        expect { delete :destroy, params: { id: @client.id } }
          .to change(Client, :count).by(-1)
      end
  
      it 'does not delete a client' do
        allow_any_instance_of(Client).to receive(:destroy).and_return(false)
        sign_in @user
        expect { delete :destroy, params: { id: @client.id } }
          .to_not change(Client, :count)
      end
    end

    context 'as a guest' do
      before do
        @client = create(:client)
      end
  
      it 'returns a 302 response' do
        delete :destroy, params: { id: @client.id }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        delete :destroy, params: { id: @client.id }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end
