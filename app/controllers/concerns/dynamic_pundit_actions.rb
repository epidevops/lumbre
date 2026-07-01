module DynamicPunditActions
  extend ActiveSupport::Concern

  included do
    if self < ActiveAdmin::BaseController
      before_action :set_custom_actions
    end
  end

  private

  def set_custom_actions
    resource_class = self.class.resource_class
    policy_class = Pundit::PolicyFinder.new(resource_class).policy
    base_policy_class = Admin::ApplicationPolicy

    custom_actions = policy_class.instance_methods - base_policy_class.instance_methods

    custom_actions.each do |action|
      self.class.send(:define_method, "authorize_#{action}") do
        authorize resource_class, action
      end

      self.class.send(:before_action, "authorize_#{action}".to_sym, only: [ action ])
    end
  end
end

# module DynamicPunditActions
#   extend ActiveSupport::Concern

#   included do
#     if self < ActiveAdmin::BaseController
#       before_action :set_custom_actions
#       class_attribute :custom_pundit_actions
#     end
#   end

#   class_methods do
#     def custom_pundit_actions_for(resource_class)
#       policy_class = Pundit::PolicyFinder.new(resource_class).policy
#       base_policy_class = Admin::ApplicationPolicy

#       policy_class.instance_methods - base_policy_class.instance_methods
#     end
#   end

#   private

#   def set_custom_actions
#     resource_class = self.class.resource_class
#     custom_actions = self.class.custom_pundit_actions_for(resource_class)

#     self.class.custom_pundit_actions = custom_actions

#     custom_actions.each do |action|
#       self.class.send(:define_method, "authorize_#{action}") do
#         authorize resource_class, action
#       end

#       self.class.send(:before_action, "authorize_#{action}".to_sym, only: [action])
#     end
#   end
# end


# module DynamicPunditActions
#   extend ActiveSupport::Concern

#   included do
#     if defined?(ActiveAdmin::BaseController) && self < ActiveAdmin::BaseController
#       before_action :set_custom_actions
#       class_attribute :custom_pundit_actions
#     end
#   end

#   class_methods do
#     def custom_pundit_actions_for(resource_class)
#       policy_class = Pundit::PolicyFinder.new(resource_class).policy
#       base_policy_class = Admin::ApplicationPolicy

#       policy_class.instance_methods - base_policy_class.instance_methods
#     end
#   end

#   private

#   def set_custom_actions
#     return unless self.class.respond_to?(:resource_class)

#     resource_class = self.class.resource_class
#     custom_actions = self.class.custom_pundit_actions_for(resource_class)

#     self.class.custom_pundit_actions = custom_actions

#     custom_actions.each do |action|
#       unless self.class.method_defined?("authorize_#{action}")
#         self.class.send(:define_method, "authorize_#{action}") do
#           authorize resource_class, action
#         end

#         self.class.send(:before_action, "authorize_#{action}".to_sym, only: [action])
#       end
#     end
#   end
# end
