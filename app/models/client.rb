class Client < ApplicationRecord
  has_many :affairs, dependent: :destroy
  validates :dni, uniqueness: true, length: { in: 6..15 }
  validates :full_name, :nacionality, length: { minimum: 5 }
end
