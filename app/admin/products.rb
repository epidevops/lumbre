ActiveAdmin.register Product do
  # Specify parameters which should be permitted for assignment
  permit_params :productable_type, :productable_id, :title, :description, :price, :recommended, :recommended_text, :discount_percent, :active, :position

  # or consider:
  #
  # permit_params do
  #   permitted = [:productable_type, :productable_id, :title, :description, :price, :recommended, :discount_percent, :active, :position]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :productable_type
  # filter :productable
  filter :title
  filter :description
  filter :price
  filter :recommended
  filter :discount_percent
  filter :active
  filter :position
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :productable_type
    column :category
    # column :productable
    column :title
    # column :description
    # column :price
    # column :recommended
    # column :discount_percent
    column :active
    column :position
    # column :created_at
    # column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :productable_type
      row :productable
      row :title
      row :description
      row :price
      row :recommended
      row :discount_percent
      row :active
      row :position
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :productable_type
      # f.input :productable
      f.input :title
      f.input :description
      f.input :price


      f.input :recommended
      f.input :recommended_text
      f.input :discount_percent
      f.input :active
      f.input :position
    end
    f.actions
  end
end
