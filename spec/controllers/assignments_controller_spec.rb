# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssignmentsController, type: :controller do
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
        it 'assigns assignments an empty array' do
          sign_in @user
          get :index
          expect(assigns(:assignments)).to be_empty
        end
      end
  
      context 'when there is data' do
        before do
          @clients = create_list(:client, 10)
          @affairs = []
          @clients.map do |c|
            @affairs << create(:affair, client_id: c.id)
          end
          @attorneys = create_list(:attorney, 10)
          @assignments = []
          (0..9).collect do |i|
            @assignments << Assignment.create(affair_id: @affairs[i].id,
                                              attorney_id: @attorneys[i].id)
          end
        end
  
        it 'assigns assignments array' do
          sign_in @user
          get :index
          expect(assigns(:assignments).count).to eq 10
        end
      end
  
      context 'assignments pagination' do
        before do
          @clients = create_list(:client, 25)
          @affairs = []
          @clients.map do |c|
            @affairs << create(:affair, client_id: c.id)
          end
          @attorneys = create_list(:attorney, 25)
          @assignments = []
          (0..24).collect do |i|
            @assignments << Assignment.create(affair_id: @affairs[i].id,
                                              attorney_id: @attorneys[i].id)
          end
        end
  
        it 'first page of three shows ten assignments' do
          sign_in @user
          get :index
          expect(assigns(:assignments).page(1))
            .to match_array(@assignments.first(10))
        end
  
        it 'second page should have ten assignments as well' do
          sign_in @user
          get :index
          expect(assigns(:assignments).page(2).length).to eq 10
        end
  
        it 'third page shows last five assignments' do
          sign_in @user
          get :index
          expect(assigns(:assignments).page(3))
            .to match_array(@assignments.last(5))
        end
  
        it 'should be empty if out of bounds' do
          sign_in @user
          get :index
          expect(assigns(:assignments).page(4)).to be_empty
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
      @attorney = create(:attorney)
      @assignment = Assignment.create(affair_id: @affair.id,
                                      attorney_id: @attorney.id)
    end

    it 'responds successfully' do
      sign_in @user
      get :show, params: { id: @assignment.id }
      expect(response).to be_successful
    end

    it 'no show with a nonexistent assignment' do
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

    it 'assigns a new assignment' do
      sign_in @user
      get :new
      expect(assigns(:assignment)).to be_a_new(Assignment)
    end
  end

  describe '#edit' do
    before do
      @user = create(:user)
      @client = create(:client)
      @affair = create(:affair, client_id: @client.id)
      @attorney = create(:attorney)
      @assignment = Assignment.create(affair_id: @affair.id,
                                      attorney_id: @attorney.id)
    end

    it 'render the edit template' do
      sign_in @user
      get :edit, params: { id: @assignment.id }
      expect(response).to render_template(:edit)
    end

    it 'load assignment params in edit template' do
      sign_in @user
      get :edit, params: { id: @assignment.id }
      expect(assigns(:assignment)).to eq(@assignment)
    end

    it 'no load with a nonexistent assignment' do
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
        @affair = create(:affair, client_id: @client.id)
        @attorney = create(:attorney)
      end
  
      context 'with valid attributes' do
        it 'adds an assignment' do
          assignment_params = { affair_id: @affair.id, attorney_id: @attorney.id }
          sign_in @user
          expect { post :create, params: { assignment: assignment_params } }
            .to change(Assignment, :count).by(1)
        end
      end
  
      context 'with invalid attributes' do
        it 'does no add an assignment' do
          assignment_params = { affair_id: nil, attorney_id: @attorney.id }
          sign_in @user
          expect { post :create, params: { assignment: assignment_params } }
            .to_not change(Assignment, :count)
        end
      end
    end

    context 'as a guest' do
      before do
        @client = create(:client)
        @affair = create(:affair, client_id: @client.id)
        @attorney = create(:attorney)
      end

      it 'returns a 302 response' do
        assignment_params = { affair_id: @affair.id, attorney_id: @attorney.id }
        post :create, params: { assignment: assignment_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        assignment_params = { affair_id: @affair.id, attorney_id: @attorney.id }
        post :create, params: { assignment: assignment_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#update' do
    context 'as an authenticated user' do
      before do
        @user = create(:user)
        @client = create(:client)
        @affair = create(:affair, client_id: @client.id)
        @attorney = create(:attorney)
        @assignment = Assignment.create(affair_id: @affair.id,
                                        attorney_id: @attorney.id)
      end
  
      it 'updates an assignment' do
        @affair2 = create(:affair, client_id: @client.id)
        assignment_params = { affair_id: @affair2.id, attorney_id: @attorney.id }
        sign_in @user
        patch :update, params: { id: @assignment.id, assignment: assignment_params }
        expect(@assignment.reload.affair_id).to eq @affair2.id
      end
  
      it 'can not update an assignment' do
        assignment_params = { affair_id: nil, attorney_id: @attorney.id }
        sign_in @user
        patch :update, params: { id: @assignment.id, assignment: assignment_params }
        expect(@assignment.reload.affair_id).to eq @assignment.affair_id
      end
    end

    context 'as a guest' do
      before do
        @client = create(:client)
        @affair = create(:affair, client_id: @client.id)
        @attorney = create(:attorney)
        @assignment = Assignment.create(affair_id: @affair.id,
                                        attorney_id: @attorney.id)
      end

      it 'returns a 302 response' do
        assignment_params = { affair_id: @affair.id, attorney_id: @attorney.id }
        patch :update, params: { id: @assignment.id, assignment: assignment_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        assignment_params = { affair_id: @affair.id, attorney_id: @attorney.id }
        patch :update, params: { id: @assignment.id, assignment: assignment_params }
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
        @attorney = create(:attorney)
        @assignment = Assignment.create(affair_id: @affair.id,
                                        attorney_id: @attorney.id)
      end
  
      it 'deletes an assignment' do
        sign_in @user
        expect { delete :destroy, params: { id: @assignment.id } }
          .to change(Assignment, :count).by(-1)
      end
  
      it 'can not delete an assignment' do
        allow_any_instance_of(Assignment).to receive(:destroy).and_return(false)
        sign_in @user
        expect { delete :destroy, params: { id: @assignment.id } }
          .to_not change(Assignment, :count)
      end
    end

    context 'as a guest' do
      before do
        @client = create(:client)
        @affair = create(:affair, client_id: @client.id)
        @attorney = create(:attorney)
        @assignment = Assignment.create(affair_id: @affair.id,
                                        attorney_id: @attorney.id)
      end

      it 'returns a 302 response' do
        delete :destroy, params: { id: @assignment.id }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        delete :destroy, params: { id: @assignment.id }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end
