# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Assignment, type: :model do
  it 'is valid with an affair id and attorney id' do
    client = create(:client)
    affair = create(:affair, client_id: client.id)
    attorney = create(:attorney)
    assignment = Assignment.new(
      affair_id: affair.id,
      attorney_id: attorney.id
    )
    expect(assignment).to be_valid
  end

  it 'is invalid without a affair' do
    assignment = Assignment.new(affair_id: nil)
    assignment.valid?
    expect(assignment.errors[:affair_id]).to include("can't be blank")
  end

  it 'is invalid without an attorney' do
    assignment = Assignment.new(attorney_id: nil)
    assignment.valid?
    expect(assignment.errors[:attorney_id]).to include("can't be blank")
  end

  it 'is invalid with a nonexistent affair' do
    assignment = Assignment.new(affair_id: 3)
    assignment.valid?
    expect(assignment.errors[:affair]).to include('must exist')
  end

  it 'is invalid with a nonexistent attorney' do
    assignment = Assignment.new(attorney_id: 3)
    assignment.valid?
    expect(assignment.errors[:attorney]).to include('must exist')
  end

  it 'allows two assignment to share a affair id' do
    client = create(:client)
    affair = create(:affair, client_id: client.id)
    attorney = create(:attorney)
    affair.assignments.create(
      attorney_id: attorney.id
    )
    other_client = create(:client)
    other_affair = create(:affair, client_id: other_client.id)
    other_assignment = other_affair.assignments.build(
      attorney_id: attorney.id
    )
    expect(other_assignment).to be_valid
  end
end
