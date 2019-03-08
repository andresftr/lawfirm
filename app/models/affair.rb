class Affair < ApplicationRecord
  belongs_to :client
  has_many :assignments, dependent: :destroy

  accepts_nested_attributes_for :assignments, reject_if: :all_blank, allow_destroy: true

  validates :file_number, uniqueness: true, length: { is: 6 }
  validates :status, length: { in: 6..15 }
  validates_associated :assignments
end
