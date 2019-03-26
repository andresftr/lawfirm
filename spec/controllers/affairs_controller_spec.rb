# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AffairsController, type: :controller do
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
        it 'assigns affairs an empty array' do
          sign_in @user
          get :index
          expect(assigns(:affairs)).to be_empty
        end
      end
  
      context 'when there is data' do
        before do
          @clients = create_list(:client, 10)
          @affairs = []
          @clients.map do |c|
            @affairs << create(:affair, client_id: c.id)
          end
        end
  
        it 'assigns affairs array' do
          sign_in @user
          get :index
          expect(assigns(:affairs).count).to eq 10
        end
      end
  
      context 'affairs pagination' do
        before do
          @clients = create_list(:client, 25)
          @affairs = []
          @clients.map do |c|
            @affairs << create(:affair, client_id: c.id)
          end
        end
  
        it 'first page of three shows ten affairs' do
          sign_in @user
          get :index
          expect(assigns(:affairs).page(1)).to match_array(@affairs.first(10))
        end
  
        it 'second page should have ten affairs as well' do
          sign_in @user
          get :index
          expect(assigns(:affairs).page(2).length).to eq 10
        end
  
        it 'third page shows last five affairs' do
          sign_in @user
          get :index
          expect(assigns(:affairs).page(3)).to match_array(@affairs.last(5))
        end
  
        it 'should be empty if out of bounds' do
          sign_in @user
          get :index
          expect(assigns(:affairs).page(4)).to be_empty
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
      @affair = create(:affair, client_id: @client.id)
    end

    it 'responds successfully' do
      sign_in @user
      get :show, params: { id: @affair.id }
      expect(response).to be_successful
    end

    it 'no show with a nonexistent affair' do
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

    it 'assigns a new affair' do
      sign_in @user
      get :new
      expect(assigns(:affair)).to be_a_new(Affair)
    end
  end

  describe '#edit' do
    before do
      @user = create(:user)
      @client = create(:client)
      @affair = create(:affair, client_id: @client.id)
    end

    it 'render the edit template' do
      sign_in @user
      get :edit, params: { id: @affair.id }
      expect(response).to render_template(:edit)
    end

    it 'load affair params in edit template' do
      sign_in @user
      get :edit, params: { id: @affair.id }
      expect(assigns(:affair)).to eq(@affair)
    end

    it 'no load with a nonexistent affair' do
      sign_in @user
      expect { get :edit, params: { id: 50 } }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#create' do
    context 'as an authenticated user' do
      before do
        @user = create(:user)
        @client = create(:client)
      end
  
      context 'with valid attributes' do
        it 'adds an affair' do
          affair_params = attributes_for(:affair).merge(client_id: @client.id)
          sign_in @user
          expect { post :create, params: { affair: affair_params } }
            .to change(@client.affairs, :count).by(1)
        end
      end
  
      context 'with invalid attributes' do
        it 'does no add an affair' do
          affair_params = attributes_for(:affair, :invalid)
          sign_in @user
          expect { post :create, params: { affair: affair_params } }
            .to_not change(@client.affairs, :count)
        end
      end  
    end
    
    context 'as a guest' do
      before do
        @client = create(:client)
      end

      it 'returns a 302 response' do
        affair_params = attributes_for(:affair).merge(client_id: @client.id)
        post :create, params: { affair: affair_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        affair_params = attributes_for(:affair).merge(client_id: @client.id)
        post :create, params: { affair: affair_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#update' do
    context 'as authenticated user' do
      before do
        @user = create(:user)
        @client = create(:client)
        @affair = create(:affair, client_id: @client.id)
      end
  
      it 'updates an affair' do
        affair_params = attributes_for(:affair, file_number: '123abc')
        sign_in @user
        patch :update, params: { id: @affair.id, affair: affair_params }
        expect(@affair.reload.file_number).to eq '123abc'
      end
  
      it 'can not update an affair' do
        affair_params = attributes_for(:affair, :invalid)
        sign_in @user
        patch :update, params: { id: @affair.id, affair: affair_params }
        expect(@affair.reload.file_number).to eq @affair.file_number
      end
    end

    context 'as a guest' do
      before do
        @client = create(:client)
        @affair = create(:affair, client_id: @client.id)
      end

      it 'returns a 302 response' do
        affair_params = attributes_for(:affair)
        patch :update, params: { id: @affair.id, affair: affair_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        affair_params = attributes_for(:affair)
        patch :update, params: { id: @affair.id, affair: affair_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#destroy' do
    context 'as an authenticated user' do
      before do
        @user = create(:user)
        @client = create(:client)
        @affair = create(:affair, client_id: @client.id)
      end
  
      it 'deletes an affair' do
        sign_in @user
        expect { delete :destroy, params: { id: @affair.id } }
          .to change(@client.affairs, :count).by(-1)
      end
  
      it 'can not delete an affair' do
        allow_any_instance_of(Affair).to receive(:destroy).and_return(false)
        sign_in @user
        expect { delete :destroy, params: { id: @affair.id } }
          .to_not change(@client.affairs, :count)
      end
    end

    context 'as a guest' do
      before do
        @client = create(:client)
        @affair = create(:affair, client_id: @client.id)
      end

      it 'returns a 302 response' do
        delete :destroy, params: { id: @affair.id }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        delete :destroy, params: { id: @affair.id }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end
