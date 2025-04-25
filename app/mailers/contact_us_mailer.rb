class ContactUsMailer < ApplicationMailer
  def contact_us_confirmation_email
    @contact = params[:contact]
    mail(to: @contact.email, subject: "Contact Confirmation")
  end

  def new_contact_us_alert_email
    @contact = params[:contact]
    mail(to: "admin@example.com", subject: "New Contact Alert")
  end
end
