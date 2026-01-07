class ContactUsMailer < ApplicationMailer
  before_action :load_restaurant_data, :attach_logo, :set_received_at

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_us_mailer.notify_contact.subject
  #
  def notify_contact
    @info_contact_email = params[:email]
    @info_contact_message = params[:inquiry]

    mail(
      to: params[:email],
      subject: I18n.t("contact_us_mailer.notify_contact.subject"),
      reply_to: "noreply@lumbreyhumo.com"
    )
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_us_mailer.notify_admin.subject
  #
  def notify_admin
    @info_contact_email = params[:email]
    @info_contact_message = params[:inquiry]

    mail(
      to: AdminUser.super_admin_users.pluck(:email),
      subject: I18n.t("contact_us_mailer.notify_admin.subject"),
      reply_to: params[:email],
      reply_to_subject: "RE: Lumbre: We've Got Your Message"
    )
  end
end
