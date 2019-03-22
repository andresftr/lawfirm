# frozen_string_literal: true

# Attorney model with its relation to assignment and validations
class Attorney < ApplicationRecord
  has_many :assignments, dependent: :destroy
  accepts_nested_attributes_for :assignments,
                                reject_if: :all_blank,
                                allow_destroy: true
  validates :dni, presence: true, uniqueness: true, length: { in: 6..12 }
  validates :full_name, :nacionality, presence: true, length: { minimum: 3 }
  validates_associated :assignments
end
