# frozen_string_literal: true

module Admin
  module Ahoy
    class VisitPolicy < Admin::ApplicationPolicy
      def self.resource_name
        "Ahoy::Visit"
      end
    end
  end
end
