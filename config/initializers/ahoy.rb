class Ahoy::Store < Ahoy::DatabaseStore
end

# set to true for JavaScript tracking
Ahoy.api = true

# set to true for geocoding (and add the geocoder gem to your Gemfile)
# we recommend configuring local geocoding as well
# see https://github.com/ankane/ahoy#geocoding
Ahoy.geocode = true
Ahoy.track_bots = true
Ahoy.cookies = :none

# End a visit after inactivity even if the Rails session is still open.
Ahoy.visit_duration = 30.minutes

# Attach visits to AdminUser on admin paths and User on the public site.
Ahoy.user_method = ->(controller) {
  if admin_ahoy_request?(controller)
    controller.current_admin_user if controller.respond_to?(:current_admin_user, true)
  else
    controller.current_user if controller.respond_to?(:current_user, true)
  end
}

def admin_ahoy_request?(controller)
  if controller.respond_to?(:admin_path?, true)
    controller.send(:admin_path?)
  else
    path = controller.request.path
    path.start_with?("/admin") ||
      I18n.available_locales.any? { |locale| path.start_with?("/#{locale}/admin") }
  end
end
