# To deliver this notification:
#
# ContactUsConfirmationNotifier.with(record: @post, message: "New post").deliver(User.all)

class ContactUsConfirmationNotifier < ApplicationNotifier
  deliver_by :email do |config|
    config.mailer = "ContactUsMailer"
    config.method = "contact_us_confirmation_email"
    config.params = ->(recipient) { { contact: recipient } }
  end

  required_param :message
end
