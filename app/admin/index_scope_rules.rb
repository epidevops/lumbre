ActiveAdmin.register IndexScopeRule do
  menu parent: "administration", priority: 7, if: proc { current_admin_user.super_admin? }

  permit_params :key, :name, :description

  filter :key
  filter :name

  index do
    id_column
    column :key
    column :name
    column :description
    column(:permissions) { |rule| rule.permission_resource_scopes.count }
    actions
  end

  show do
    attributes_table_for(resource) do
      row :key
      row :name
      row :description
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :key, input_html: { disabled: !f.object.new_record? }
      f.input :name
      f.input :description
    end
    f.actions
  end
end
