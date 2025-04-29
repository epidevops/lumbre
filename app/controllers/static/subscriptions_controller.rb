class Static::SubscriptionsController < ApplicationController
  # include StaticContacts

  SUBSCRIBING_SUCCESS_MESSAGE = "You have subscribed! Check your inbox for great offers and rewards."

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.find_by(email: contact_params[:email])

    if @contact.nil?
      @contact = Contact.new(contact_params)
      @contact.subscribed = true
      @contact.save
    elsif !@contact.subscribed?
      @contact.update(subscribed: true)
    else
      # send email to admin
    end

    flash.now[:notice] = SUBSCRIBING_SUCCESS_MESSAGE

    respond_to do |format|
      format.html { redirect_to root_path, notice: SUBSCRIBING_SUCCESS_MESSAGE }
      format.turbo_stream
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:email)
  end
end
