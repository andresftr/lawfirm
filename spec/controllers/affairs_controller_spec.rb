# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AffairsController, type: :controller do
  describe '#index' do
    it 'responds successfully' do
      get :index
      aggregate_failures do
        expect(response).to be_successful
        expect(response).to have_http_status '200'
      end
    end

    context 'when there is no data' do
      it 'assigns affairs an empty array' do
        get :index
        expect(assigns(:affairs)).to be_empty
      end
    end

    context 'when there is data' do
      before do
        @clients = create_list(:client, 10)
        @affairs = []
        @clients.map do |c|
          @affairs << FactoryBot.create(:affair, client_id: c.id)
        end
      end

      it 'assigns affairs array' do
        get :index
        expect(assigns(:affairs).count).to eq 10
      end
    end

    context 'affairs pagination' do
      before do
        @clients = create_list(:client, 25)
        @affairs = []
        @clients.map do |c|
          @affairs << FactoryBot.create(:affair, client_id: c.id)
        end
      end

      it 'first page of three shows ten affairs' do
        get :index
        expect(assigns(:affairs).page(1)).to match_array(@affairs.first(10))
      end

      it 'second page should have ten affairs as well' do
        get :index
        expect(assigns(:affairs).page(2).length).to eq 10
      end

      it 'third page shows last five affairs' do
        get :index
        expect(assigns(:affairs).page(3)).to match_array(@affairs.last(5))
      end

      it 'should be empty if out of bounds' do
        get :index
        expect(assigns(:affairs).page(4)).to be_empty
      end
    end
  end

  describe '#show' do
    before do
      @client = FactoryBot.create(:client)
      @affair = FactoryBot.create(:affair, client_id: @client.id)
    end

    it 'responds successfully' do
      get :show, params: { id: @affair.id }
      expect(response).to be_successful
    end

    it 'no show with a nonexistent affair' do
      expect { get :show, params: { id: 50 } }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#new' do
    it 'render the new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'assigns a new affair' do
      get :new
      expect(assigns(:affair)).to be_a_new(Affair)
    end
  end

  describe '#edit' do
    before do
      @client = FactoryBot.create(:client)
      @affair = FactoryBot.create(:affair, client_id: @client.id)
    end

    it 'render the edit template' do
      get :edit, params: { id: @affair.id }
      expect(response).to render_template(:edit)
    end

    it 'load affair params in edit template' do
      get :edit, params: { id: @affair.id }
      expect(assigns(:affair)).to eq(@affair)
    end

    it 'no load with a nonexistent affair' do
      expect { get :edit, params: { id: 50 } }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#create' do
    before do
      @client = FactoryBot.create(:client)
    end

    context 'with valid attributes' do
      it 'adds an affair' do
        affair_params = FactoryBot.attributes_for(:affair)
                                  .merge(client_id: @client.id)
        expect { post :create, params: { affair: affair_params } }
          .to change(@client.affairs, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does no add an affair' do
        affair_params = FactoryBot.attributes_for(:affair, :invalid)
        expect { post :create, params: { affair: affair_params } }
          .to_not change(@client.affairs, :count)
      end
    end
  end

  describe '#update' do
    before do
      @client = FactoryBot.create(:client)
      @affair = FactoryBot.create(:affair, client_id: @client.id)
    end

    it 'updates an affair' do
      affair_params = FactoryBot.attributes_for(:affair, file_number: '123abc')
      patch :update, params: { id: @affair.id, affair: affair_params }
      expect(@affair.reload.file_number).to eq '123abc'
    end

    it 'can not update an affair' do
      affair_params = FactoryBot.attributes_for(:affair, :invalid)
      patch :update, params: { id: @affair.id, affair: affair_params }
      expect(@affair.reload.file_number).to eq @affair.file_number
    end
  end

  describe '#destroy' do
    before do
      @client = FactoryBot.create(:client)
      @affair = FactoryBot.create(:affair, client_id: @client.id)
    end

    it 'deletes an affair' do
      expect { delete :destroy, params: { id: @affair.id } }
        .to change(@client.affairs, :count).by(-1)
    end

    it 'can not delete an affair' do
      allow_any_instance_of(Affair).to receive(:destroy).and_return(false)
      expect { delete :destroy, params: { id: @affair.id } }
        .to_not change(@client.affairs, :count)
    end
  end
end
