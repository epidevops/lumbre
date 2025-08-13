ActiveAdmin.register Product do
  menu parent: "application", priority: 3

  # Specify parameters which should be permitted for assignment
  permit_params :productable_type, :productable_id, :category, :title, :description, :price, :recommended, :recommended_text, :discount_percent, :options, :active, :position,
                I18n.available_locales.map { |locale| "title_#{Mobility.normalize_locale(locale)}".to_sym },
                I18n.available_locales.map { |locale| "description_#{Mobility.normalize_locale(locale)}".to_sym },
                I18n.available_locales.map { |locale| "recommended_text_#{Mobility.normalize_locale(locale)}".to_sym },
                photos: []


  # or consider:
  #
  # permit_params do
  #   permitted = [:productable_type, :productable_id, :title, :description, :price, :recommended, :discount_percent, :active, :position]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  includes :photos_attachments

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
      row :category
      row :title
      row :description
      row :price
      row :recommended
      row :recommended_text
      row :discount_percent
      row :active
      row :position
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form partial: "form"

  member_action :delete_photo, method: :delete do
    photo = ActiveStorage::Attachment.find(params[:photo_id])
    if photo.record == resource
      photo.purge_later
      redirect_to edit_admin_product_path(resource), notice: "Photo deleted successfully"
    else
      redirect_to edit_admin_product_path(resource), alert: "Photo not found"
    end
  end
end
