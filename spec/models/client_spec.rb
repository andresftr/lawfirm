# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client, type: :model do
  it 'is valid with a dni, full name, address, nacionality and birthdate' do
    client = build(:client)
    expect(client).to be_valid
  end

  it 'is invalid without a dni' do
    client = build(:client, dni: nil)
    client.valid?
    expect(client.errors[:dni]).to include("can't be blank")
  end

  it 'is invalid without a full name' do
    client = build(:client, full_name: nil)
    client.valid?
    expect(client.errors[:full_name]).to include("can't be blank")
  end

  it 'is valid without a address' do
    client = build(:client, :without_address)
    client.valid?
    expect(client).to be_valid
  end

  it 'is invalid without a nacionality' do
    client = build(:client, nacionality: nil)
    client.valid?
    expect(client.errors[:nacionality]).to include("can't be blank")
  end

  it 'is invalid without a birthdate' do
    client = build(:client, birthdate: nil)
    client.valid?
    expect(client.errors[:birthdate]).to include("can't be blank")
  end

  it 'is invalid with a duplicate dni' do
    create(:client, dni: '123456')
    client = build(:client, dni: '123456')
    client.valid?
    expect(client.errors[:dni]).to include('has already been taken')
  end

  it 'is invalid a dni with a length less than 6' do
    client = Client.new(dni: '12345')
    client.valid?
    expect(client.errors[:dni])
      .to include('is too short (minimum is 6 characters)')
  end

  it 'is invalid a dni with a length more than 12' do
    client = Client.new(dni: '123456454664654654545')
    client.valid?
    expect(client.errors[:dni])
      .to include('is too long (maximum is 12 characters)')
  end

  it 'is invalid a full name with a length less than 3' do
    client = Client.new(full_name: 'l')
    client.valid?
    expect(client.errors[:full_name])
      .to include('is too short (minimum is 3 characters)')
  end

  it 'is invalid a nacionality with a length less than 3' do
    client = Client.new(nacionality: 'c')
    client.valid?
    expect(client.errors[:nacionality])
      .to include('is too short (minimum is 3 characters)')
  end
end
