class Attorney < ApplicationRecord
  has_many :assignments, dependent: :destroy

  accepts_nested_attributes_for :assignments, reject_if: :all_blank, allow_destroy: true

  validates :dni, uniqueness: true, length: { in: 6..15 }
  validates :full_name, :nacionality, length: { minimum: 5 }
  validates_associated :assignments
end
