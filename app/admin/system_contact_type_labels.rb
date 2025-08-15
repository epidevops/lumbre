ActiveAdmin.register SystemContactTypeLabel do
  menu parent: "administration", priority: 3, if: proc { current_admin_user.super_admin? || Flipper.enabled?(:super_admin_access, current_admin_user) }
  config.sort_order = "contact_type_asc"
  # Specify parameters which should be permitted for assignment
  permit_params :id, :contact_type, :label, :created_at, :updated_at, :_destroy

  # or consider:
  #
  # permit_params do
  #   permitted = [:contact_type, :label]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :contact_type
  filter :label
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :contact_type
    column :label
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :contact_type
      row :label
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :contact_type
      f.input :label
    end
    f.actions
  end
end
