# Configure Active Storage URL generation
Rails.application.config.active_storage.resolve_model_to_route = :rails_storage_proxy

# # Set default URL options for Active Storage
# Rails.application.config.active_storage.default_url_options = {
#   host: ENV.fetch('HOST', '127.0.0.1:3000'),
#   protocol: Rails.env.production? ? 'https' : 'http'
# }

# Configure caching for Active Storage
# ActiveSupport.on_load(:active_storage_blob) do
#   ActiveStorage::DiskController.after_action only: :show do
#     response.set_header("Cache-Control", "max-age=3600, public")
#   end
# end
