class ContactUsMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_us_mailer.notify_contact.subject
  #
  def notify_contact
    @title = "Message Received"
    @greeting = "Thank you for contacting Lumbre. We've got your message and will get back to you as soon as possible."
    @info_title = "Request Details"
    @info_contact_email = params[:email]
    @info_contact_message = params[:inquiry]

    mail to: params[:email], subject: "Lumbre: We've Got Your Message", from: email_address_with_name("noreply@lumbreyhumo.com", "Lumbre"), reply_to: "noreply@lumbreyhumo.com"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_us_mailer.notify_admin.subject
  #
  def notify_admin
    @title = "New Request"
    @greeting = "A new contact request has been received. Please find the details below."
    @info_title = "Request Details"
    @info_contact_email = params[:email]
    @info_contact_message = params[:inquiry]

    mail to: AdminUser.super_admin_users.pluck(:email), subject: "Lumbre: New Contact Us Request Received", from: email_address_with_name("noreply@lumbreyhumo.com", "Lumbre"), reply_to: params[:email], reply_to_subject: "RE: Lumbre: We've Got Your Message"
  end
end
