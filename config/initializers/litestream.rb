# Use this hook to configure the litestream-ruby gem.
# All configuration options will be available as environment variables, e.g.
# config.replica_bucket becomes LITESTREAM_REPLICA_BUCKET
# This allows you to configure Litestream using Rails encrypted credentials,
# or some other mechanism where the values are only available at runtime.

Rails.application.configure do
  # Configure Litestream through environment variables or Rails credentials
  litestream_credentials = Rails.application.credentials.tigris

  config.litestream.replica_bucket = ENV["LITESTREAM_REPLICA_BUCKET"] || litestream_credentials&.bucket
  config.litestream.replica_key_id = ENV["LITESTREAM_ACCESS_KEY_ID"] || litestream_credentials&.access_key_id
  config.litestream.replica_access_key = ENV["LITESTREAM_SECRET_ACCESS_KEY"] || litestream_credentials&.secret_access_key
  config.litestream.replica_endpoint = ENV["LITESTREAM_AWS_ENDPOINT_URL_S3"] || litestream_credentials&.endpoint

  # Configure the default Litestream config path
  config.config_path = Rails.root.join("config", "litestream.yml")

  # Configure the Litestream dashboard
  #
  # Set the default base controller class
  # config.litestream.base_controller_class = "MyApplicationController"
  #
  # Set authentication credentials for Litestream dashboard
  # config.litestream.username = litestream_credentials&.username
  # config.litestream.password = litestream_credentials&.password
end
