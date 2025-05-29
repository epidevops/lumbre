ActiveAdmin.register Product do
  menu priority: 4

  # Specify parameters which should be permitted for assignment
  permit_params :productable_type, :productable_id, :title, :description, :price, :recommended, :recommended_text, :discount_percent, :active, :position, *I18n.available_locales.map { |locale| "title_#{Mobility.normalize_locale(locale)}" }, *I18n.available_locales.map { |locale| "description_#{Mobility.normalize_locale(locale)}" }, *I18n.available_locales.map { |locale| "recommended_text_#{Mobility.normalize_locale(locale)}" }


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
  form partial: "form"


  # form do |f|
  #   f.semantic_errors(*f.object.errors.attribute_names)
  #   tabs do
  #     tab "Details" do
  #       f.inputs do
  #         f.input :productable_type
  #         # f.input :productable
  #         f.input :price
  #         f.input :options
  #         f.input :recommended
  #         f.input :discount_percent
  #         f.input :active, as: :flowbite_toggle
  #         f.input :position
  #       end
  #     end

  #     I18n.available_locales.each do |locale|
  #       tab "Content (#{locale.upcase})" do
  #         f.inputs do
  #           f.input "title_#{Mobility.normalize_locale(locale)}", as: :string, label: "Title (#{locale.upcase})"
  #           f.input "description_#{Mobility.normalize_locale(locale)}", as: :text, label: "Description (#{locale.upcase})"
  #           f.input "recommended_text_#{Mobility.normalize_locale(locale)}", as: :text, label: "Recommended Text (#{locale.upcase})"
  #         end
  #       end
  #     end
  #   end
  #   f.actions
  # end
end
