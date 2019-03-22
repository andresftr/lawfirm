# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  it 'is valid with a name, email and password' do
    user = User.new(
      name: 'Andres Felipe',
      email: 'andres@gmail.com',
      password: '123abc'
    )
    expect(user).to be_valid
  end

  it 'is valid without a name' do
    user = build(:user, name: nil)
    expect(user).to be_valid
  end

  it 'is invalid without a name' do
    user = build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'is invalid without a password' do
    user = build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end
end
