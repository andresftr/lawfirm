# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Affair, type: :model do
  it 'is valid with all its attributes' do
    client = create(:client)
    affair = build(:affair, client_id: client.id)
    expect(affair).to be_valid
  end

  it 'does not allow duplicate affair file number' do
    client = create(:client)

    create(:affair, file_number: '123abc', client_id: client.id)

    new_affair = build(:affair, file_number: '123abc', client_id: client.id)
    new_affair.valid?
    expect(new_affair.errors[:file_number]).to include('has already been taken')
  end

  it 'is invalid without a file number' do
    affair = Affair.new(file_number: nil)
    affair.valid?
    expect(affair.errors[:file_number]).to include("can't be blank")
  end

  it 'is invalid without a client' do
    affair = Affair.new(client_id: nil)
    affair.valid?
    expect(affair.errors[:client_id]).to include("can't be blank")
  end

  it 'is invalid with a nonexistent client' do
    affair = Affair.new(client_id: 3)
    affair.valid?
    expect(affair.errors[:client]).to include('must exist')
  end

  it 'is invalid without a start date' do
    affair = Affair.new(start_date: nil)
    affair.valid?
    expect(affair.errors[:start_date]).to include("can't be blank")
  end

  it 'is valid without a finish date' do
    client = create(:client)
    affair = build(:affair, :without_finish_date, client_id: client.id)
    affair.valid?
    expect(affair).to be_valid
  end

  it 'is invalid without a status' do
    affair = Affair.new(status: nil)
    affair.valid?
    expect(affair.errors[:start_date]).to include("can't be blank")
  end

  it 'is invalid with a file number length different that 6' do
    affair = Affair.new(file_number: '46435354')
    affair.valid?
    expect(affair.errors[:file_number])
      .to include('is the wrong length (should be 6 characters)')
  end

  it 'is invalid with a status length less than 6' do
    affair = Affair.new(status: 'ok')
    affair.valid?
    expect(affair.errors[:status])
      .to include('is too short (minimum is 6 characters)')
  end

  it 'is invalid with a status length more than 6' do
    affair = Affair.new(status: 'babarubarubaba tete')
    affair.valid?
    expect(affair.errors[:status])
      .to include('is too long (maximum is 15 characters)')
  end
end
