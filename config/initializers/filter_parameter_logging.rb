# Be sure to restart your server when you modify this file.

# Configure parameters to be partially matched (e.g. passw matches password) and filtered from the log file.
# Use this to limit dissemination of sensitive information.
# See the ActiveSupport::ParameterFilter documentation for supported notations and behaviors.
Rails.application.config.filter_parameters += [
  :passw, :email, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn, :cvv, :cvc, :otp_attempt, :otp_secret, :otp_backup_codes,
  # Additional security filters for admin tools
  :query, :sql, :statement, # Blazer query content
  :exception, :error_message, :backtrace, # Exception Track sensitive data
  :session_id, :csrf_token, :authenticity_token, # Session security
  :api_key, :access_token, :refresh_token, # API tokens
  :private_key, :public_key, :certificate_key # Certificates
]
