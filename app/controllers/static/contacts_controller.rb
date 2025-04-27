class Static::ContactsController < ApplicationController
  CONTACT_MESSAGE_SUCCESS_MESSAGE = "Your message has been sent. We will get back to you as soon as possible."

  def create
    @contact = Contact.find_by(email: contact_params[:email])

    if @contact.nil?
      @contact = Contact.new(contact_params)
    else
      @contact.contact_messages.build(message: contact_params[:contact_messages_attributes]["0"][:message])
    end

    if @contact.save
      # ContactUsConfirmationNotifier.with(record: @contact_message, message: @contact_message.message).deliver(@contact)
      # NewContactUsAlertNotifier.with(record: @contact_message, message: @contact_message.message).deliver(AdminUser.first)
      flash.now[:notice] = CONTACT_MESSAGE_SUCCESS_MESSAGE

      respond_to do |format|
        format.html { redirect_to root_path, notice: CONTACT_MESSAGE_SUCCESS_MESSAGE }
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace("contact_form", partial: "static/contacts/form", locals: { contact: Contact.new }),
            turbo_stream.replace("flash", partial: "layouts/flash")
          ]
        }
      end
    else
      logger.error("Contact message creation failed: #{@contact.errors.full_messages}")
      flash.now[:notice] = CONTACT_MESSAGE_SUCCESS_MESSAGE

      respond_to do |format|
        format.html { redirect_to root_path, notice: CONTACT_MESSAGE_SUCCESS_MESSAGE }
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace("contact_form", partial: "static/contacts/form", locals: { contact: Contact.new }),
            turbo_stream.replace("flash", partial: "layouts/flash")
          ]
        }
      end
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:email, contact_messages_attributes: [ :message ])
  end
end
