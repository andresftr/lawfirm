class Affair < ApplicationRecord
  belongs_to :client
  has_many :assignment, dependent: :destroy
  validates :file_number, uniqueness: true, length: { is: 6 }
  validates :status, length: { in: 6..15 }
end
