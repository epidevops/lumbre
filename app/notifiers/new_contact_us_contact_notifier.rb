# To deliver this notification:
#
# NewContactUsContactNotifier.with(record: @post, message: "New post").deliver(User.all)

class NewContactUsContactNotifier < ApplicationNotifier
  deliver_by :email do |config|
    config.mailer = "ContactUsMailer"
    config.method = "notify_contact"
    config.params = -> {
      {
        email: params[:email],
        inquiry: params[:inquiry],
        received_at: params[:received_at],
        restaurant_email: params[:restaurant_email]
      }
    }
  end

  # Add required params
  required_param :email, :inquiry, :restaurant_email
end
