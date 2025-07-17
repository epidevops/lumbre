require "test_helper"

class ContactUsMailerTest < ActionMailer::TestCase
  test "notify_contact" do
    email = "test@example.com"
    inquiry = "Test message"

    mail = ContactUsMailer.with(email: email, inquiry: inquiry).notify_contact

    assert_equal "Lumbre: We've Got Your Message", mail.subject
    assert_equal [ email ], mail.to
    assert_equal [ "noreply@lumbreyhumo.com" ], mail.from
    assert_equal "noreply@lumbreyhumo.com", mail.reply_to.first
    assert_match "Thank you for contacting Lumbre", mail.body.encoded
    assert_match "Test message", mail.body.encoded
    assert_match "Message Received", mail.body.encoded
  end

  test "notify_admin" do
    email = "customer@example.com"
    inquiry = "Customer inquiry"

    mail = ContactUsMailer.with(email: email, inquiry: inquiry).notify_admin

    assert_equal "Lumbre: New Contact Us Request Received", mail.subject
    assert_equal AdminUser.super_admin_users.pluck(:email), mail.to
    assert_equal [ "noreply@lumbreyhumo.com" ], mail.from
    assert_equal email, mail.reply_to.first
    assert_match "A new contact request has been received", mail.body.encoded
    assert_match "Customer inquiry", mail.body.encoded
    assert_match "customer@example.com", mail.body.encoded
  end
end
