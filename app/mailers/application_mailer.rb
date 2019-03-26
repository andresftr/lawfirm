# frozen_string_literal: true

# Application Mailer Class to all about mail
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
