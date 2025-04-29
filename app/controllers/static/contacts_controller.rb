class Static::ContactsController < ApplicationController
  CONTACT_MESSAGE_SUCCESS_MESSAGE = "Your message has been sent. We will get back to you as soon as possible."

  def create
    @contact = Contact.find_by(email: contact_params[:email])

    if @contact.nil?
      @contact = Contact.new(contact_params)
    else
      @contact.contact_messages.build(message: contact_params[:contact_messages_attributes]["0"][:message])
    end

    flash.now[:notice] = CONTACT_MESSAGE_SUCCESS_MESSAGE

    if @contact.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: CONTACT_MESSAGE_SUCCESS_MESSAGE }
        format.turbo_stream
      end
    else
      logger.error("Contact message creation failed: #{@contact.errors.full_messages}")
      respond_to do |format|
        format.html { redirect_to root_path, notice: CONTACT_MESSAGE_SUCCESS_MESSAGE }
        format.turbo_stream
      end
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:email, contact_messages_attributes: [ :message ])
  end
end
