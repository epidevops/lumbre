# To deliver this notification:
#
# NewContactUsAlertNotifier.with(record: @post, message: "New post").deliver(User.all)

class NewContactUsAlertNotifier < ApplicationNotifier
  deliver_by :email do |config|
    config.mailer = "ContactUsMailer"
    config.method = "new_contact_us_alert_email"
    config.params = ->(recipient) { { contact: recipient } }
  end
end
