# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Attorney, type: :model do
  it 'is valid with a dni, full name, address and nacionality' do
    attorney = build(:attorney)
    expect(attorney).to be_valid
  end

  it 'is invalid without a dni' do
    attorney = build(:attorney, dni: nil)
    attorney.valid?
    expect(attorney.errors[:dni]).to include("can't be blank")
  end

  it 'is invalid without a full_name' do
    attorney = build(:attorney, full_name: nil)
    attorney.valid?
    expect(attorney.errors[:full_name]).to include("can't be blank")
  end

  it 'is valid without a address' do
    attorney = build(:attorney, :without_address)
    attorney.valid?
    expect(attorney).to be_valid
  end

  it 'is invalid without a nacionality' do
    attorney = build(:attorney, nacionality: nil)
    attorney.valid?
    expect(attorney.errors[:nacionality]).to include("can't be blank")
  end

  it 'is invalid with a duplicate dni' do
    create(:attorney, dni: '987654')
    attorney = build(:attorney, dni: '987654')
    attorney.valid?
    expect(attorney.errors[:dni]).to include('has already been taken')
  end

  it 'is invalid a dni with a length less than 6' do
    attorney = Attorney.new(dni: '6465')
    attorney.valid?
    expect(attorney.errors[:dni])
      .to include('is too short (minimum is 6 characters)')
  end

  it 'is invalid a dni with a length more than 12' do
    attorney = Attorney.new(dni: '64656757654544')
    attorney.valid?
    expect(attorney.errors[:dni])
      .to include('is too long (maximum is 12 characters)')
  end

  it 'is invalid a full name with a length less than 3' do
    attorney = Attorney.new(full_name: 'p')
    attorney.valid?
    expect(attorney.errors[:full_name])
      .to include('is too short (minimum is 3 characters)')
  end

  it 'is invalid a nacionality with a length less than 3' do
    attorney = Attorney.new(nacionality: 'm')
    attorney.valid?
    expect(attorney.errors[:nacionality])
      .to include('is too short (minimum is 3 characters)')
  end
end
