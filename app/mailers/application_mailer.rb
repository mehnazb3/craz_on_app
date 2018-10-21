class ApplicationMailer < ActionMailer::Base
  default from: CRAZ_ON_SETTINGS[:mailer_default_from]
end
