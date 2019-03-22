# frozen_string_literal: true

# Assignment model with its relation to affair and attorney, and validations.
class Assignment < ApplicationRecord
  belongs_to :affair
  belongs_to :attorney
  validates :affair, uniqueness: { scope: :attorney }
  validates :affair_id, :attorney_id, presence: true
end
