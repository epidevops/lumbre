# frozen_string_literal: true

module Admin
  module Ahoy
    class EventPolicy < Admin::ApplicationPolicy
      def self.resource_name
        "Ahoy::Event"
      end
    end
  end
end
