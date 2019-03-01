class Assignment < ApplicationRecord
  belongs_to :affair
  belongs_to :attorney
  validates :affair, uniqueness: { scope: :attorney }
end
