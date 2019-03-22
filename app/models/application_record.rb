# frozen_string_literal: true

# Default application record of rails
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
