require "application_system_test_case"

class AdminOtpLoginFlowTest < ApplicationSystemTestCase
  setup do
    @admin_user = admin_users(:one)
    @password = ENV.fetch("DYNAMIC_PASSWORD") { Rails.application.credentials.dig(:passwords, :dynamic) || "secret1234!" }
    I18n.locale = :en
  end

  test "admin without OTP signs in normally" do
    @admin_user.update!(otp_required_for_login: false)

    visit new_admin_user_session_path(locale: :en)

    # Wait for form to be available
    assert_selector "form", wait: 10

    within "form" do
      fill_in "Email", with: @admin_user.email
      fill_in "Password", with: @password
      click_on "Sign In"
    end

    # Should be logged in successfully
    assert_text "Signed in successfully", wait: 10
    # Admin root might include locale in system tests
    assert(current_path == admin_root_path || current_path == "/en/admin",
           "Expected to be on admin root path, but was on: #{current_path}")
  end

  test "admin with OTP enabled is redirected to challenge page" do
    @admin_user.update!(
      otp_required_for_login: true,
      otp_secret: AdminUser.generate_otp_secret
    )

    visit new_admin_user_session_path(locale: :en)

    # Wait for form to be available
    assert_selector "form", wait: 10

    within "form" do
      fill_in "Email", with: @admin_user.email
      fill_in "Password", with: @password
      click_on "Sign In"
    end

    # Should be redirected to OTP challenge page
    assert_current_path admin_user_otp_challenge_path(locale: :en), wait: 10
    assert_text I18n.t("active_admin.otp.session.title"), wait: 10
    assert_text I18n.t("active_admin.otp.session.required"), wait: 10
  end

  test "OTP challenge page shows correct form elements" do
    @admin_user.update!(
      otp_required_for_login: true,
      otp_secret: AdminUser.generate_otp_secret
    )

    # Login to get to challenge page
    visit new_admin_user_session_path(locale: :en)
    fill_in "Email", with: @admin_user.email
    fill_in "Password", with: @password
    click_on "Sign In"

    # Should be on challenge page
    assert_current_path admin_user_otp_challenge_path(locale: :en)

    # Check form elements
    assert_field I18n.t("active_admin.otp.session.code_label")
    assert_button I18n.t("active_admin.otp.session.verify_button")
    assert_link I18n.t("active_admin.devise.links.sign_in")
    assert_link I18n.t("active_admin.otp.session.cancel")
  end

  test "successful OTP verification completes login" do
    @admin_user.update!(
      otp_required_for_login: true,
      otp_secret: AdminUser.generate_otp_secret
    )

    # Login to get to challenge page
    visit new_admin_user_session_path(locale: :en)
    fill_in "Email", with: @admin_user.email
    fill_in "Password", with: @password
    click_on "Sign In"

    # Enter valid OTP
    valid_otp = @admin_user.current_otp
    fill_in I18n.t("active_admin.otp.session.code_label"), with: valid_otp
    click_on I18n.t("active_admin.otp.session.verify_button")

    # Should be logged in successfully
    assert_text I18n.t("active_admin.otp.session.success")
    # Admin root might include locale in system tests
    assert(current_path == admin_root_path || current_path == "/en/admin",
           "Expected to be on admin root path, but was on: #{current_path}")
  end

  test "invalid OTP shows error and stays on challenge page" do
    @admin_user.update!(
      otp_required_for_login: true,
      otp_secret: AdminUser.generate_otp_secret
    )

    # Login to get to challenge page
    visit new_admin_user_session_path(locale: :en)
    fill_in "Email", with: @admin_user.email
    fill_in "Password", with: @password
    click_on "Sign In"

    # Enter invalid OTP
    fill_in I18n.t("active_admin.otp.session.code_label"), with: "000000"
    click_on I18n.t("active_admin.otp.session.verify_button")

    # Should stay on challenge page
    assert_current_path admin_user_otp_verify_path(locale: :en)
    # Should still show the challenge form
    assert_text I18n.t("active_admin.otp.session.title")
    assert_field I18n.t("active_admin.otp.session.code_label")
  end

  test "cancel link returns to login page" do
    @admin_user.update!(
      otp_required_for_login: true,
      otp_secret: AdminUser.generate_otp_secret
    )

    # Login to get to challenge page
    visit new_admin_user_session_path(locale: :en)
    fill_in "Email", with: @admin_user.email
    fill_in "Password", with: @password
    click_on "Sign In"

    # Click cancel
    click_on I18n.t("active_admin.otp.session.cancel")

    # Should return to login page
    assert_current_path new_admin_user_session_path(locale: :en)
    assert_text I18n.t("active_admin.otp.session.cancelled")
  end

  test "accessing challenge page without pending session redirects to login" do
    visit admin_user_otp_challenge_path(locale: :en)

    # Should redirect to login page
    assert_current_path new_admin_user_session_path(locale: :en)
    assert_text I18n.t("active_admin.otp.session.expired")
  end

  test "backup code works for authentication" do
    @admin_user.update!(
      otp_required_for_login: true,
      otp_secret: AdminUser.generate_otp_secret
    )

    # Generate backup codes
    backup_codes = @admin_user.generate_otp_backup_codes!
    @admin_user.save!

    # Login to get to challenge page
    visit new_admin_user_session_path(locale: :en)
    fill_in "Email", with: @admin_user.email
    fill_in "Password", with: @password
    click_on "Sign In"

    # Enter backup code
    backup_code = backup_codes.first
    fill_in I18n.t("active_admin.otp.session.code_label"), with: backup_code
    click_on I18n.t("active_admin.otp.session.verify_button")

    # Should be logged in successfully
    assert_text I18n.t("active_admin.otp.session.success")
    # Admin root might include locale in system tests
    assert(current_path == admin_root_path || current_path == "/en/admin",
           "Expected to be on admin root path, but was on: #{current_path}")
  end
end
