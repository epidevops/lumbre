ActiveAdmin.register Permission do
  menu parent: "administration", priority: 3, if: proc { current_admin_user.super_admin? }

  permit_params :role_id, :created_at, :updated_at,
                permission_grants_attributes: %i[
                  id permission_id access_authorization_id granted created_at updated_at _destroy
                ],
                permission_resource_scopes_attributes: %i[
                  id permission_id access_resource_id index_scope_rule_id created_at updated_at _destroy
                ]

  filter :role
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column :role
    column(:access_types) { |permission| permission.granted_access_types.map(&:name).join(", ") }
    column :created_at
    actions
  end

    show do
    attributes_table_for(resource) do
      row :role
      row(:access_types) { |permission| permission.granted_access_types.map(&:name).join(", ") }
      row :created_at
      row :updated_at
    end

    permission_access_types_for_form.each do |access_type|
      matrix = PermissionFormMatrix.new(resource, access_type)

      panel t("active_admin.permissions.access_types.#{access_type.key}", default: access_type.name) do
        row_groups = matrix.resources? ? matrix.grouped_resource_rows : { nil => matrix.rows }

        row_groups.each do |menu_parent, rows|
          if matrix.resources? && menu_parent.present?
            div class: "mb-2 font-semibold uppercase text-sm text-gray-600" do
              menu_parent == "(root)" ? t("active_admin.permissions.navigation.root") : menu_parent.humanize
            end
          end

          table_for rows do
            column(t("active_admin.permissions.columns.component")) { |row| row[:label] }
            if matrix.resources?
              column(t("active_admin.permissions.columns.index_scope")) do |row|
                resource_scope = row[:resource_scope]
                key = resource_scope&.index_scope_rule&.key || "all"
                t("active_admin.permissions.scopes.#{key}", default: key.humanize)
              end
            end
            matrix.action_columns.each do |action|
              column(permission_action_column_label(action), class: "text-center") do |row|
                authorization = row[:cells][action]
                authorization && resource.granted?(authorization) ? status_tag("yes") : status_tag("no")
              end
            end
          end
        end
      end
    end
  end

  form partial: "form"

  controller do
    helper Admin::PermissionsHelper

    def new
      build_resource
      resource.assign_default_grants!
      super
    end

    def edit
      resource.assign_default_grants! if resource.permission_grants.empty?
      super
    end

    def scoped_collection
      super.includes(
        permission_grants: { access_authorization: :access_resource },
        permission_resource_scopes: [ :access_resource, :index_scope_rule ]
      )
    end
  end
end
