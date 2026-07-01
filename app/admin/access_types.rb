ActiveAdmin.register AccessType do
  menu parent: "administration", priority: 6, if: proc { current_admin_user.super_admin? }

  actions :index, :show

  permit_params :name, :key

  filter :key
  filter :name

  index do
    id_column
    column :key
    column :name
    column(:authorizations) { |access_type| access_type.access_authorizations.count }
    actions
  end

  show do
    attributes_table_for(resource) do
      row :key
      row :name
      row :created_at
      row :updated_at
    end

    panel "Authorizations" do
      table_for resource.access_authorizations.order(:label) do
        column :key
        column :label
        column :access_resource
        column :action
      end
    end
  end
end
