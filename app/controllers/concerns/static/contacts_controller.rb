class Static::ContactsController < ApplicationController
  before_action :set_contact, only: [ :create ]
  before_action :subscribing?, only: [ :create ]
  before_action :sending_contact_message?, only: [ :create ]

  SUBSCRIBING_SUCCESS_MESSAGE = "You have subscribed! Check your inbox for great offers and rewards."
  CONTACT_MESSAGE_SUCCESS_MESSAGE = "Your message has been sent. We will get back to you as soon as possible."


  def create
    if subscribing? && !@contact.subscribed
      @contact.subscribed = contact_params[:subscribed]
      if @contact.save
        # @contact.send_welcome_email
        handle_response(SUBSCRIBING_SUCCESS_MESSAGE)
      else
        logger.error("Contact creation failed: #{@contact.errors.full_messages}")
        handle_response(SUBSCRIBING_SUCCESS_MESSAGE)
      end
    else
      handle_response(SUBSCRIBING_SUCCESS_MESSAGE)
    end

    if sending_contact_message?
      if @contact.contact_messages.create!(message: contact_params[:message])
        handle_response(CONTACT_MESSAGE_SUCCESS_MESSAGE)
      else
        logger.error("Contact message creation failed: #{@contact.errors.full_messages}")
        handle_response(CONTACT_MESSAGE_SUCCESS_MESSAGE)
      end
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:email, :subscribed, :message)
  end

  def set_contact
    @contact = Contact.find_or_create_by!(email: contact_params[:email])
  end

  def subscribing?
    contact_params[:subscribed].present? && contact_params[:subscribed] == "true"
  end

  def sending_contact_message?
    contact_params[:message].present?
  end

  def handle_response(notice)
    respond_to do |format|
      format.html { redirect_to root_path, notice: notice }
      format.turbo_stream { flash.now[:notice] = notice }
    end
  end
end
