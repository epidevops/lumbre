require "test_helper"

class AdminUserOtpTest < ActiveSupport::TestCase
  setup do
    @admin_user = AdminUser.new(
      email: "test@example.com",
      first_name: "Test",
      last_name: "User"
    )
  end

  test "should generate OTP secret" do
    secret = AdminUser.generate_otp_secret
    assert_not_nil secret
    assert_equal 32, secret.length
    assert_match(/\A[A-Z2-7]+\z/, secret) # Base32 format
  end


  test "should generate current OTP" do
    @admin_user.otp_secret = AdminUser.generate_otp_secret
    otp = @admin_user.current_otp
    assert_not_nil otp
    assert_equal 6, otp.length
    assert_match(/\A\d{6}\z/, otp) # 6 digits
  end

  test "should generate provisioning URI" do
    @admin_user.otp_secret = AdminUser.generate_otp_secret
    uri = @admin_user.otp_provisioning_uri(@admin_user.email, issuer: "Lumbre")

    assert_includes uri, "otpauth://totp/"
    # Email might be URL encoded in the URI
    assert(uri.include?(@admin_user.email) || uri.include?(CGI.escape(@admin_user.email)))
    assert_includes uri, "issuer=Lumbre"
    assert_includes uri, "secret=#{@admin_user.otp_secret}"
  end

  test "should validate correct OTP" do
    @admin_user.otp_secret = AdminUser.generate_otp_secret
    current_otp = @admin_user.current_otp

    assert @admin_user.validate_and_consume_otp!(current_otp)
  end

  test "should reject invalid OTP" do
    @admin_user.otp_secret = AdminUser.generate_otp_secret

    assert_not @admin_user.validate_and_consume_otp!("123456")
  end

  test "should reject empty OTP" do
    @admin_user.otp_secret = AdminUser.generate_otp_secret

    assert_not @admin_user.validate_and_consume_otp!("")
    assert_not @admin_user.validate_and_consume_otp!(nil)
  end

  test "should prevent OTP reuse" do
    @admin_user.otp_secret = AdminUser.generate_otp_secret
    @admin_user.password = "password123"  # Provide required password
    @admin_user.save!

    current_otp = @admin_user.current_otp

    # First use should succeed
    assert @admin_user.validate_and_consume_otp!(current_otp)

    # Second use should fail (same timestep)
    assert_not @admin_user.validate_and_consume_otp!(current_otp)
  end

  test "should serialize backup codes" do
    backup_codes = [ "ABC123", "DEF456", "GHI789" ]
    @admin_user.otp_backup_codes = backup_codes

    # Test serialization
    assert_equal backup_codes, @admin_user.otp_backup_codes
  end

  test "should generate backup codes if method exists" do
    @admin_user.otp_secret = AdminUser.generate_otp_secret

    if @admin_user.respond_to?(:generate_otp_backup_codes!)
      backup_codes = @admin_user.generate_otp_backup_codes!

      # Test returned backup codes
      assert_not_nil backup_codes
      assert backup_codes.is_a?(Array)
      assert_equal 10, backup_codes.length

      # Test that returned codes are plaintext
      backup_codes.each do |code|
        assert code.is_a?(String)
        assert code.length > 0
        # Should not look like a bcrypt hash
        assert_not code.start_with?("$2a$")
      end

      # Test stored backup codes (these are hashed)
      assert_not_nil @admin_user.otp_backup_codes
      assert @admin_user.otp_backup_codes.is_a?(Array)
      assert_equal 10, @admin_user.otp_backup_codes.length

      # Stored codes should be hashed
      @admin_user.otp_backup_codes.each do |hashed_code|
        assert hashed_code.is_a?(String)
        assert hashed_code.start_with?("$2a$")
      end
    else
      skip "generate_otp_backup_codes! method not available"
    end
  end

  test "should handle otp_required_for_login flag" do
    assert_not @admin_user.otp_required_for_login?

    @admin_user.otp_required_for_login = true
    assert @admin_user.otp_required_for_login?

    @admin_user.otp_required_for_login = false
    assert_not @admin_user.otp_required_for_login?
  end

  test "should include devise two factor authenticatable module" do
    assert @admin_user.class.included_modules.any? { |m| m.to_s.include?("TwoFactorAuthenticatable") }
  end

  test "should have required database columns" do
    # Test that the migration added the required columns
    assert AdminUser.column_names.include?("otp_secret")
    assert AdminUser.column_names.include?("otp_backup_codes")
    assert AdminUser.column_names.include?("consumed_timestep")
    assert AdminUser.column_names.include?("otp_required_for_login")
  end

  test "should respond to devise two factor methods" do
    @admin_user.otp_secret = AdminUser.generate_otp_secret

    # Required methods for two-factor authentication
    assert_respond_to @admin_user, :current_otp
    assert_respond_to @admin_user, :otp_provisioning_uri
    assert_respond_to @admin_user, :validate_and_consume_otp!
    assert_respond_to @admin_user.class, :generate_otp_secret
  end

  test "should have correct backup code configuration" do
    @admin_user.otp_secret = AdminUser.generate_otp_secret

    if @admin_user.respond_to?(:generate_otp_backup_codes!)
      backup_codes = @admin_user.generate_otp_backup_codes!

      # Should generate exactly 10 backup codes (plaintext)
      assert_equal 10, backup_codes.length

      # Each plaintext code should be a valid string
      backup_codes.each do |code|
        assert code.is_a?(String)
        assert code.length > 0
        # Should not be a hash
        assert_not code.start_with?("$2a$")
      end

      # All plaintext codes should be unique
      assert_equal backup_codes.length, backup_codes.uniq.length

      # Should have 10 stored hashed codes
      assert_equal 10, @admin_user.otp_backup_codes.length

      # Stored codes should be hashed and unique
      @admin_user.otp_backup_codes.each do |hashed_code|
        assert hashed_code.start_with?("$2a$")
      end
      assert_equal @admin_user.otp_backup_codes.length, @admin_user.otp_backup_codes.uniq.length
    else
      skip "generate_otp_backup_codes! method not available"
    end
  end
end
