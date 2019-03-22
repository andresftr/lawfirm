# frozen_string_literal: true

# Client model with its relation to affair and validations
class Client < ApplicationRecord
  has_many :affairs, dependent: :destroy
  validates :dni, presence: true, uniqueness: true, length: { in: 6..12 }
  validates :full_name, :nacionality, presence: true, length: { minimum: 3 }
  validates :birthdate, presence: true
  validates_associated :affairs
end
