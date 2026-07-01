ActiveAdmin.register AccessAuthorization do
  menu parent: "administration", priority: 4, if: proc { current_admin_user.super_admin? }

  actions :index, :show

  permit_params :access_type_id, :access_resource_id, :key, :label, :action

  filter :access_type
  filter :access_resource
  filter :key
  filter :label
  filter :action

  index do
    id_column
    column :access_type
    column :key
    column :label
    column :access_resource
    column :action
    actions
  end

  show do
    attributes_table_for(resource) do
      row :access_type
      row :key
      row :label
      row :access_resource
      row :action
      row :created_at
      row :updated_at
    end
  end
end
