# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttorneysController, type: :controller do
  describe '#index' do
    it 'responds successfully' do
      get :index
      aggregate_failures do
        expect(response).to be_successful
        expect(response).to have_http_status '200'
      end
    end

    context 'when there is no data' do
      it 'assigns attorneys an empty array' do
        get :index
        expect(assigns(:attorneys)).to be_empty
      end
    end

    context 'when there is data' do
      before do
        @attorney = create_list(:attorney, 10)
      end

      it 'assigns attorney array' do
        get :index
        expect(assigns(:attorneys).count).to eq 10
      end
    end

    context 'attorneys pagination' do
      before do
        @attorneys = create_list(:attorney, 25)
      end

      it 'first page of three shows ten attorneys' do
        get :index
        expect(assigns(:attorneys).page(1)).to match_array(@attorneys.first(10))
      end

      it 'second page should have ten attorneys as well' do
        get :index
        expect(assigns(:attorneys).page(2).length).to eq 10
      end

      it 'third page shows last five attorneys' do
        get :index
        expect(assigns(:attorneys).page(3)).to match_array(@attorneys.last(5))
      end

      it 'should be empty if out of bounds' do
        get :index
        expect(assigns(:attorneys).page(4)).to be_empty
      end
    end
  end

  describe '#show' do
    before do
      @attorney = FactoryBot.create(:attorney)
    end

    it 'responds successfully' do
      get :show, params: { id: @attorney.id }
      expect(response).to be_successful
    end

    it 'no show with a nonexistent attorney' do
      expect { get :show, params: { id: 50 } }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#new' do
    it 'render the new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'assigns a new attorney' do
      get :new
      expect(assigns(:attorney)).to be_a_new(Attorney)
    end
  end

  describe '#edit' do
    before do
      @attorney = FactoryBot.create(:attorney)
    end

    it 'render the edit template' do
      get :edit, params: { id: @attorney.id }
      expect(response).to render_template(:edit)
    end

    it 'load attorney params in edit template' do
      get :edit, params: { id: @attorney.id }
      expect(assigns(:attorney)).to eq(@attorney)
    end

    it 'no load with a nonexistent attorney' do
      expect { get :edit, params: { id: 50 } }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#create' do
    context 'with valid attributes' do
      it 'adds a attorney' do
        attorney_params = FactoryBot.attributes_for(:attorney)
        expect { post :create, params: { attorney: attorney_params } }
          .to change(Attorney, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not add a attorney' do
        attorney_params = FactoryBot.attributes_for(:attorney, :invalid)
        expect { post :create, params: { attorney: attorney_params } }
          .to_not change(Attorney, :count)
      end
    end
  end

  describe '#update' do
    before do
      @attorney = FactoryBot.create(:attorney)
    end

    it 'updates an attorney' do
      attorney_params = FactoryBot.attributes_for(
        :attorney,
        full_name: 'New Attorney Name'
      )
      patch :update, params: { id: @attorney.id, attorney: attorney_params }
      expect(@attorney.reload.full_name).to eq 'New Attorney Name'
    end

    it 'can not update an attorney' do
      attorney_params = FactoryBot.attributes_for(:attorney, :invalid)
      patch :update, params: { id: @attorney.id, attorney: attorney_params }
      expect(@attorney.reload.full_name).to eq @attorney.full_name
    end
  end

  describe '#destroy' do
    before do
      @attorney = FactoryBot.create(:attorney)
    end

    it 'deletes an attorney' do
      expect { delete :destroy, params: { id: @attorney.id } }
        .to change(Attorney, :count).by(-1)
    end

    it 'can not delete an attorney' do
      allow_any_instance_of(Attorney).to receive(:destroy).and_return(false)
      expect { delete :destroy, params: { id: @attorney.id } }
        .to_not change(Attorney, :count)
    end
  end
end
