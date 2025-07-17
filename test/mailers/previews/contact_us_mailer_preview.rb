# Preview all emails at http://localhost:3000/rails/mailers/contact_us_mailer
class ContactUsMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/contact_us_mailer/notify_contact
  def notify_contact
    ContactUsMailer.with(
      email: "customer@example.com",
      inquiry: "Hi, I'm interested in making a reservation for this Friday evening. Could you please let me know if you have availability for a party of 4 around 7 PM? Thank you!"
    ).notify_contact
  end

  # Preview this email at http://localhost:3000/rails/mailers/contact_us_mailer/notify_admin
  def notify_admin
    ContactUsMailer.with(
      email: "customer@example.com",
      inquiry: "Hi, I'm interested in making a reservation for this Friday evening. Could you please let me know if you have availability for a party of 4 around 7 PM? Thank you!"
    ).notify_admin
  end
end
