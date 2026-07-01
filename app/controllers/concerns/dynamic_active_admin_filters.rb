module DynamicActiveAdminFilters
  extend ActiveSupport::Concern

  included do
    if self < ActiveAdmin::BaseController
      before_action :apply_dynamic_filters, only: [ :index ]

      def index
        super
      end

      private
        # Method to dynamically show or hide filters
        def apply_dynamic_filters
          resource = current_admin_user

          if resource.present? && policy(resource).respond_to?(:filters?)
            should_show_filters = policy(resource).filters?

            active_admin_config.filters = should_show_filters
          end
        end
    end
  end
end
