class Static::ContactsController < ApplicationController
  CONTACT_MESSAGE_SUCCESS_MESSAGE = "Your message has been sent. We will get back to you as soon as possible."


  def create
    @contact_message = @contact.contact_messages.new(message: contact_params[:message])
    if @contact_message.save
      # ContactUsConfirmationNotifier.with(record: @contact_message, message: @contact_message.message).deliver(@contact)
      # NewContactUsAlertNotifier.with(record: @contact_message, message: @contact_message.message).deliver(AdminUser.first)
      respond_to do |format|
        format.html { redirect_to root_path, notice: CONTACT_MESSAGE_SUCCESS_MESSAGE }
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace("flash", partial: "layouts/flash", locals: { notice: CONTACT_MESSAGE_SUCCESS_MESSAGE }),
            turbo_stream.replace("contact_form", partial: "static/contacts/form", locals: { contact: Contact.new })
          ]
        }
      end
    else
      logger.error("Contact message creation failed: #{@contact.errors.full_messages}")
      respond_to do |format|
        format.html { redirect_to root_path, notice: CONTACT_MESSAGE_SUCCESS_MESSAGE }
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace("flash", partial: "layouts/flash", locals: { notice: CONTACT_MESSAGE_SUCCESS_MESSAGE }),
            turbo_stream.replace("contact_form", partial: "static/contacts/form", locals: { contact: Contact.new })
          ]
        }
      end
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:email, :message)
  end
end
