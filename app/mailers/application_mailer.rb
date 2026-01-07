class ApplicationMailer < ActionMailer::Base
  prepend_view_path "app/views/emails"
  default from: email_address_with_name("noreply@lumbreyhumo.com", "Lumbre")
  layout "mailer"

  private

  # Load restaurant data and social links for email templates
  def load_restaurant_data
    @restaurant ||= Restaurant.primary.includes(:socials).first
    @socials ||= @restaurant&.socials&.active || []
  end

  # Attach the Lumbre logo as an inline image for emails
  def attach_logo
    logo_path = Rails.root.join("public/images/LOGO-LUMBRE_original.png")
    attachments.inline["logo.png"] = File.read(logo_path) if File.exist?(logo_path)
  end

  # Set default received timestamp if not provided
  def set_received_at
    @received_at ||= params[:received_at] || Time.current
  end
end
