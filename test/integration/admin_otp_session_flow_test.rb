require "test_helper"

class AdminOtpSessionFlowTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = admin_users(:one)
    @password = ENV.fetch("DYNAMIC_PASSWORD") { Rails.application.credentials.dig(:passwords, :dynamic) || "secret1234!" }
    I18n.locale = :en
  end

  test "admin without OTP signs in normally" do
    @admin_user.update!(otp_required_for_login: false)

    post admin_user_session_path(locale: :en), params: {
      admin_user: {
        email: @admin_user.email,
        password: @password
      }
    }

    # Should redirect to admin area
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  test "admin with OTP enabled redirects to challenge after login" do
    @admin_user.update!(
      otp_required_for_login: true,
      otp_secret: AdminUser.generate_otp_secret
    )

    post admin_user_session_path(locale: :en), params: {
      admin_user: {
        email: @admin_user.email,
        password: @password
      }
    }

    assert_redirected_to admin_user_otp_challenge_path(locale: :en)
  end

  test "accessing OTP challenge without pending session redirects to login" do
    get admin_user_otp_challenge_path(locale: :en)

    assert_redirected_to new_admin_user_session_path(locale: :en)
  end

  test "OTP challenge page loads correctly after login" do
    @admin_user.update!(
      otp_required_for_login: true,
      otp_secret: AdminUser.generate_otp_secret
    )

    # Login first to get redirected to OTP challenge
    post admin_user_session_path(locale: :en), params: {
      admin_user: {
        email: @admin_user.email,
        password: @password
      }
    }

    # Follow redirect to OTP challenge
    follow_redirect!
    assert_response :success
    assert_select "h2", text: /#{Regexp.escape(I18n.t('active_admin.otp.session.title'))}/
    assert_select "input[name='admin_user[otp_attempt]']"
  end

  test "successful OTP verification completes login" do
    @admin_user.update!(
      otp_required_for_login: true,
      otp_secret: AdminUser.generate_otp_secret
    )

    # Login first to get redirected to OTP challenge
    post admin_user_session_path(locale: :en), params: {
      admin_user: {
        email: @admin_user.email,
        password: @password
      }
    }

    # Should be redirected to OTP challenge
    assert_redirected_to admin_user_otp_challenge_path(locale: :en)

    # Generate valid OTP code
    valid_otp = @admin_user.current_otp

    # Now verify the OTP
    post admin_user_otp_verify_path(locale: :en), params: {
      admin_user: {
        otp_attempt: valid_otp
      }
    }

    # Should redirect to admin area after successful verification
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  test "invalid OTP code shows error" do
    @admin_user.update!(
      otp_required_for_login: true,
      otp_secret: AdminUser.generate_otp_secret
    )

    # Login first to get redirected to OTP challenge
    post admin_user_session_path(locale: :en), params: {
      admin_user: {
        email: @admin_user.email,
        password: @password
      }
    }

    # Try invalid OTP code
    post admin_user_otp_verify_path(locale: :en), params: {
      admin_user: {
        otp_attempt: "000000" # Invalid code
      }
    }

    # Should stay on challenge page with error
    assert_response :success
    assert_select "h2", text: /#{Regexp.escape(I18n.t('active_admin.otp.session.title'))}/
  end

  test "backup code works for OTP verification" do
    @admin_user.update!(
      otp_required_for_login: true,
      otp_secret: AdminUser.generate_otp_secret
    )

    # Generate backup codes
    backup_codes = @admin_user.generate_otp_backup_codes!
    @admin_user.save!

    # Login first to get redirected to OTP challenge
    post admin_user_session_path(locale: :en), params: {
      admin_user: {
        email: @admin_user.email,
        password: @password
      }
    }

    # Use first backup code
    backup_code = backup_codes.first

    post admin_user_otp_verify_path(locale: :en), params: {
      admin_user: {
        otp_attempt: backup_code
      }
    }

    # Should redirect to admin area after successful verification
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end
end
