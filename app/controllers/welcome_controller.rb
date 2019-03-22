# frozen_string_literal: true

# Welcome controller with index actions
class WelcomeController < ApplicationController
  def index
    @clients = Client.all
    @affairs = Affair.all
    @attorneys = Attorney.all
    @assignments = Assignment.all
  end
end
