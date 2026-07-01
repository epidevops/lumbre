module Admin::PermissionsHelper
  PERMISSION_TAB_ORDER = [
    AccessType::NAVIGATION,
    AccessType::RESOURCES,
    AccessType::PAGES
  ].freeze

  def permission_access_types_for_form
    types_by_key = AccessType.where(key: PERMISSION_TAB_ORDER).index_by(&:key)
    PERMISSION_TAB_ORDER.filter_map { |key| types_by_key[key] }
  end

  def permission_access_type_icon(access_type)
    case access_type.key
    when AccessType::NAVIGATION
      heroicon("bars-3", class: "me-2")
    when AccessType::RESOURCES
      heroicon("table-cells", class: "me-2")
    when AccessType::PAGES
      heroicon("document-text", class: "me-2")
    else
      heroicon("key", class: "me-2")
    end
  end

  def permission_action_column_label(action)
    case action
    when "enabled"
      t("active_admin.permissions.columns.enabled")
    else
      t("active_admin.permissions.actions.#{action}", default: action_label_default(action))
    end
  end

  def permission_index_scope_options
    IndexScopeRule.ordered.map do |rule|
      [ t("active_admin.permissions.scopes.#{rule.key}", default: rule.name), rule.id ]
    end
  end

  def permission_grant_checkbox(form, permission, authorization, grant_index)
    grant = permission.grant_for(authorization)
    prefix = "#{form.object_name}[permission_grants_attributes][#{grant_index}]"
    checkbox_class = "w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"

    fields = [
      hidden_field_tag("#{prefix}[access_authorization_id]", authorization.id),
      tag.div(class: "flex justify-center") do
        safe_join([
          hidden_field_tag("#{prefix}[granted]", "0"),
          check_box_tag("#{prefix}[granted]", "1", grant.granted, class: checkbox_class)
        ])
      end
    ]
    fields.unshift(hidden_field_tag("#{prefix}[id]", grant.id)) if grant.persisted?

    safe_join(fields)
  end

  def permission_resource_scope_select(form, permission, access_resource, scope_index)
    resource_scope = permission.resource_scope_for_form(access_resource)
    prefix = "#{form.object_name}[permission_resource_scopes_attributes][#{scope_index}]"
    select_class = "block w-full min-w-[8rem] rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white text-sm"

    fields = [
      hidden_field_tag("#{prefix}[access_resource_id]", access_resource.id),
      select_tag(
        "#{prefix}[index_scope_rule_id]",
        options_for_select(permission_index_scope_options, resource_scope.index_scope_rule_id),
        class: select_class
      )
    ]
    fields.unshift(hidden_field_tag("#{prefix}[id]", resource_scope.id)) if resource_scope.persisted?

    safe_join(fields)
  end

  private

    def action_label_default(action)
      case action
      when /\Aba_(.+)\z/ then "Batch: #{::Regexp.last_match(1).humanize}"
      when /\Ama_(.+)\z/ then "Member: #{::Regexp.last_match(1).humanize}"
      when /\Aca_(.+)\z/ then "Collection: #{::Regexp.last_match(1).humanize}"
      when /\Aai_(.+)\z/ then "Action item: #{::Regexp.last_match(1).humanize}"
      else action.humanize
      end
    end
end
