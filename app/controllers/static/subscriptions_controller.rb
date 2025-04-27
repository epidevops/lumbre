class Static::SubscriptionsController < ApplicationController
  # include StaticContacts

  SUBSCRIBING_SUCCESS_MESSAGE = "You have subscribed! Check your inbox for great offers and rewards."

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      debugger
      # SubscribeConfirmationNotifier.with(record: @contact).deliver(@contact)
      # NewSubscribeAlertNotifier.with(record: @contact).deliver(AdminUser.first)
    end
    # if @contact.subscribed?
    #   # TODO: Send subcription update email
    #   respond_to do |format|
    #     format.html { redirect_to root_path, notice: SUBSCRIBING_SUCCESS_MESSAGE }
    #     format.turbo_stream {
    #       render turbo_stream: [
    #         turbo_stream.replace("flash", partial: "layouts/flash", locals: { notice: SUBSCRIBING_SUCCESS_MESSAGE })
    #       ]
    #     }
    #   end
    # else
    #   @contact.update(subscribed: true)
    #   SubscribeConfirmationNotifier.with(record: @contact).deliver(@contact)
    #   NewSubscribeAlertNotifier.with(record: @contact).deliver(AdminUser.first)
    #   respond_to do |format|
    #     format.html { redirect_to root_path, notice: SUBSCRIBING_SUCCESS_MESSAGE }
    #     format.turbo_stream {
    #       render turbo_stream: [
    #         turbo_stream.replace("flash", partial: "layouts/flash", locals: { notice: SUBSCRIBING_SUCCESS_MESSAGE })
    #       ]
    #     }
    #   end
    # end
  end

  private

  def contact_params
    params.require(:contact).permit(:email)
  end
end
