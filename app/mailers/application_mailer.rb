class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.aws[:mailer_user_name]
  layout 'mailer'
end
