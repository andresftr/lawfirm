# frozen_string_literal: true

# Affair model with its relation to assignment and client and also validations.
class Affair < ApplicationRecord
  belongs_to :client
  has_many :assignments, dependent: :destroy
  accepts_nested_attributes_for :assignments,
                                reject_if: :all_blank,
                                allow_destroy: true
  validates :file_number, presence: true, uniqueness: true, length: { is: 6 }
  validates :status, presence: true, length: { in: 6..15 }
  validates :client_id, :start_date, presence: true
  validates_associated :assignments
end
