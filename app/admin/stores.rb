ActiveAdmin.register Store do
  # Specify parameters which should be permitted for assignment
  permit_params :active, :name, :primary, :slogan

  # or consider:
  #
  # permit_params do
  #   permitted = [:active, :name, :primary, :slogan]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :active
  filter :created_at
  filter :name
  filter :primary
  filter :slogan
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :active
    column :created_at
    column :name
    column :primary
    column :slogan
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :active
      row :created_at
      row :name
      row :primary
      row :slogan
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  # form do |f|
  #   f.semantic_errors(*f.object.errors.attribute_names)
  #   f.inputs do
  #     f.input :active
  #     f.input :name
  #     f.input :primary
  #     f.input :slogan
  #   end
  #   f.actions
  # end
  form partial: "form"
end
