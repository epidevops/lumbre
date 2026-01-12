class Static::ContactsController < ApplicationController
  # rate_limit to: 10, within: 3.minutes, by: -> { request.domain }, with: -> { redirect_to root_path, alert: "Try again later." }, only: :create
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to root_url, alert: "Try again later." }
  CONTACT_MESSAGE_SUCCESS_MESSAGE = "Your message has been sent. We will get back to you as soon as possible."

  def create
    @contact = Contact.find_by(email: contact_params[:email])

    if @contact.nil?
      @contact = Contact.new(contact_params)
    else
      @contact.contact_messages.build(message: contact_params[:contact_messages_attributes]["0"][:message])
    end

    if @contact.save
      NewContactUsContactNotifier.with(record: @contact, email: @contact.email, inquiry: @contact.contact_messages.last.message, restaurant_email: restaurant_email).deliver(@contact)
      NewContactUsAdminNotifier.with(record: @contact, email: @contact.email, inquiry: @contact.contact_messages.last.message, restaurant_email: restaurant_email).deliver(AdminUser.super_admin_users)
      respond_to do |format|
        format.html { redirect_to root_path, notice: CONTACT_MESSAGE_SUCCESS_MESSAGE }
        format.turbo_stream { flash.now[:notice] = CONTACT_MESSAGE_SUCCESS_MESSAGE }
      end
    else
      logger.error("Contact message creation failed: #{@contact.errors.full_messages}")
      respond_to do |format|
        format.html { redirect_to root_path, notice: CONTACT_MESSAGE_SUCCESS_MESSAGE }
        format.turbo_stream { flash.now[:notice] = CONTACT_MESSAGE_SUCCESS_MESSAGE }
      end
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:email, contact_messages_attributes: [ :message ])
  end

  def restaurant_email
    @restaurant ||= Restaurant.primary.includes(:emails).first
    @restaurant.emails.active.first&.email ||
      ENV.fetch("GMAIL_USER_NAME") { Rails.application.credentials.dig(:gmail_smtp, :username) }
  end
end
