require "test_helper"

class ContactUsMailerTest < ActionMailer::TestCase
  setup do
    @email = "test@example.com"
    @inquiry = "I would like to make a reservation for 4 people this Friday evening."
    @received_at = Time.zone.parse("2026-01-07 18:30:00")
  end

  # ========== notify_contact tests ==========

  test "notify_contact sends email to customer" do
    mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_contact

    assert_equal [ @email ], mail.to
    assert_equal [ "noreply@lumbreyhumo.com" ], mail.from
    assert_equal "noreply@lumbreyhumo.com", mail.reply_to.first
  end

  test "notify_contact uses i18n subject in English" do
    I18n.with_locale(:en) do
      mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_contact
      assert_equal "Lumbre: We've Got Your Message", mail.subject
    end
  end

  test "notify_contact uses i18n subject in French" do
    I18n.with_locale(:fr) do
      mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_contact
      assert_equal "Lumbre: Nous avons reçu votre message", mail.subject
    end
  end

  test "notify_contact uses i18n subject in Spanish" do
    I18n.with_locale(:"es-MX") do
      mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_contact
      assert_equal "Lumbre: Hemos Recibido Tu Mensaje", mail.subject
    end
  end

  test "notify_contact includes customer message in body" do
    mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_contact

    assert_match @inquiry, mail.body.encoded
    assert_match "reservation for 4 people", mail.body.encoded
  end

  test "notify_contact includes translated greeting" do
    mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_contact

    assert_match "Thank you for contacting Lumbre", mail.body.encoded
    assert_match "Message Received", mail.body.encoded
  end

  test "notify_contact includes logo attachment" do
    mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_contact

    assert_not_empty mail.attachments
    assert mail.attachments["logo.png"].present?
    assert_match "image/png", mail.attachments["logo.png"].content_type
    assert mail.attachments["logo.png"].inline?
  end

  test "notify_contact loads restaurant and social links" do
    mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_contact

    # Check that social links are rendered in HTML body
    html_part = mail.html_part.body.to_s
    assert_match /facebook/i, html_part
    assert_match /instagram/i, html_part
    assert_match restaurants(:one).socials.first.url, html_part
  end

  test "notify_contact includes social links in text version" do
    mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_contact

    text_part = mail.text_part.body.to_s
    assert_match "Follow us:", text_part
    assert_match "Facebook", text_part
    assert_match "Instagram", text_part
  end

  test "notify_contact includes received timestamp" do
    mail = ContactUsMailer.with(
      email: @email,
      inquiry: @inquiry,
      received_at: @received_at
    ).notify_contact

    body = mail.body.encoded
    assert_match "Received:", body
  end

  test "notify_contact uses current time when no timestamp provided" do
    freeze_time do
      mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_contact

      # The email should include a timestamp close to now
      assert_match "Received:", mail.body.encoded
    end
  end

  test "notify_contact has both HTML and text parts" do
    mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_contact

    assert mail.html_part.present?
    assert mail.text_part.present?
    assert_match "text/html", mail.html_part.content_type
    assert_match "text/plain", mail.text_part.content_type
  end

  test "notify_contact includes footer tagline" do
    mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_contact

    body = mail.body.encoded
    assert_match "Experience exceptional cuisine and hospitality", body
  end

  test "notify_contact includes copyright in footer" do
    mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_contact

    body = mail.body.encoded
    # Copyright symbol may be encoded as ©, \u00A9, or =C2=A9
    assert_match /#{Time.current.year} Lumbre/, body
    assert_match "All rights reserved", body
  end

  # ========== notify_admin tests ==========

  test "notify_admin sends email to super admins" do
    mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_admin

    assert_equal AdminUser.super_admin_users.pluck(:email), mail.to
    assert_equal [ "noreply@lumbreyhumo.com" ], mail.from
    assert_equal @email, mail.reply_to.first
  end

  test "notify_admin uses i18n subject in English" do
    I18n.with_locale(:en) do
      mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_admin
      assert_equal "Lumbre: New Contact Request Received", mail.subject
    end
  end

  test "notify_admin uses i18n subject in German" do
    I18n.with_locale(:de) do
      mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_admin
      assert_equal "Lumbre: Neue Kontaktanfrage Erhalten", mail.subject
    end
  end

  test "notify_admin uses i18n subject in Portuguese" do
    I18n.with_locale(:"pt-BR") do
      mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_admin
      assert_equal "Lumbre: Nova Solicitação de Contato Recebida", mail.subject
    end
  end

  test "notify_admin includes customer email and message" do
    mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_admin

    body = mail.body.encoded
    assert_match @email, body
    assert_match @inquiry, body
    assert_match "reservation for 4 people", body
  end

  test "notify_admin includes admin notification badge" do
    mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_admin

    html_part = mail.html_part.body.to_s
    assert_match "Admin Notification", html_part
  end

  test "notify_admin includes translated greeting" do
    mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_admin

    body = mail.body.encoded
    assert_match "A new contact request has been received", body
    assert_match "New Request", body
  end

  test "notify_admin includes logo attachment" do
    mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_admin

    assert_not_empty mail.attachments
    assert mail.attachments["logo.png"].present?
    assert_match "image/png", mail.attachments["logo.png"].content_type
    assert mail.attachments["logo.png"].inline?
  end

  test "notify_admin includes reply button with mailto link" do
    mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_admin

    html_part = mail.html_part.body.to_s
    assert_match "Reply to Customer", html_part
    assert_match "mailto:#{@email}", html_part
  end

  test "notify_admin includes received and sent timestamps" do
    mail = ContactUsMailer.with(
      email: @email,
      inquiry: @inquiry,
      received_at: @received_at
    ).notify_admin

    body = mail.body.encoded
    assert_match "Received:", body
    assert_match "Sent:", body
  end

  test "notify_admin has both HTML and text parts" do
    mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_admin

    assert mail.html_part.present?
    assert mail.text_part.present?
    assert_match "text/html", mail.html_part.content_type
    assert_match "text/plain", mail.text_part.content_type
  end

  test "notify_admin includes contact email label" do
    mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_admin

    body = mail.body.encoded
    assert_match "Contact Email:", body
  end

  test "notify_admin includes footer with admin notification message" do
    mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_admin

    body = mail.body.encoded
    assert_match "automated admin notification", body
    assert_match "Lumbre Contact System", body
  end

  # ========== Integration tests ==========

  test "both emails load restaurant data without errors" do
    assert_nothing_raised do
      ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_contact.deliver_now
      ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_admin.deliver_now
    end
  end

  test "emails work when restaurant has no social links" do
    # Temporarily remove social links
    Restaurant.primary.first.socials.update_all(active: false)

    assert_nothing_raised do
      mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_contact
      assert_not_nil mail.body
    end
  ensure
    # Restore social links
    Restaurant.primary.first.socials.update_all(active: true)
  end

  test "emails render correctly in multiple locales" do
    [ :en, :fr, :de, :"es-MX", :"pt-BR" ].each do |locale|
      I18n.with_locale(locale) do
        assert_nothing_raised do
          mail = ContactUsMailer.with(email: @email, inquiry: @inquiry).notify_contact
          assert_not_nil mail.subject
          assert_not_nil mail.body
        end
      end
    end
  end
end
