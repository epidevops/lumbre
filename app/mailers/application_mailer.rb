class ApplicationMailer < ActionMailer::Base
  prepend_view_path "app/views/emails"
  default from: email_address_with_name("noreply@lumbreyhumo.com", "Lumbre")
  layout "mailer"
end
