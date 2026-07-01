module AdminAuthorizable
  extend ActiveSupport::Concern

  def authorized_for?(resource, action)
    return true if super_admin?

    authorization_exists?(
      authorization_scope_for(resource, action)
    )
  end

  def authorized_nav?(menu_key)
    return true if super_admin?

    authorization_exists?(AccessAuthorization.for_menu(menu_key))
  end

  def index_scope_for(resource)
    return "all" if super_admin?

    access_resource = AccessResource.find_by(resource_class: resource.to_s)
    return IndexScopeRule::DEFAULT_KEY if access_resource.nil?

    rule_keys = PermissionResourceScope
      .joins(:permission, :index_scope_rule)
      .where(permissions: { role_id: role_ids }, access_resource: access_resource)
      .pluck("index_scope_rules.key")

    IndexScopeRule::PRIORITY.find { |key| rule_keys.include?(key) } || IndexScopeRule::DEFAULT_KEY
  end

  def peer_admin_user_ids
    AdminUser.joins(:roles).where(roles: { id: role_ids }).distinct.pluck(:id)
  end

  private

    def role_ids
      roles.pluck(:id)
    end

    def authorization_scope_for(resource, action)
      resource_name = resource.is_a?(AccessResource) ? resource.resource_class : resource.to_s
      candidates = authorization_action_candidates(action.to_s)

      AccessAuthorization
        .joins(:access_resource, :access_type)
        .where(access_resources: { resource_class: resource_name })
        .where(action: candidates)
        .where(access_types: { key: [ AccessType::RESOURCES, AccessType::PAGES ] })
    end

    def authorization_action_candidates(action)
      candidates = [ action ]
      case action
      when /\Ama_(.+)\z/
        candidates << ::Regexp.last_match(1)
      when /\Aca_(.+)\z/
        candidates << ::Regexp.last_match(1)
      when /\Aba_destroy\z/
        candidates << "destroy_all"
      when /\Aba_(.+)\z/
        candidates << "batch_actions"
      when /\Aai_(.+)\z/
        candidates << ::Regexp.last_match(1)
      else
        unless action.start_with?("ma_", "ba_", "ca_", "ai_")
          candidates << "ma_#{action}"
          candidates << "ca_#{action}"
        end
      end
      candidates.uniq
    end

    def authorization_exists?(authorizations)
      return false if role_ids.blank?

      authorizations
        .joins(permission_grants: :permission)
        .merge(PermissionGrant.granted)
        .exists?(permissions: { role_id: role_ids })
    end
end
