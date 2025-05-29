ActiveAdmin.register Store do
  # Specify parameters which should be permitted for assignment
  permit_params :active, :primary,
    *I18n.available_locales.map { |locale| "name_#{Mobility.normalize_locale(locale)}" },
    *I18n.available_locales.map { |locale| "slogan_#{Mobility.normalize_locale(locale)}" },
    events_attributes: %i[id eventable_type eventable_id label start_day end_day start_time end_time active _destroy]

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

  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    tabs do
      tab "Details" do
        f.inputs do
          f.input :active
          f.input :primary
        end
      end

      I18n.available_locales.each do |locale|
        tab "Content (#{locale.upcase})" do
          f.inputs do
            f.input "name_#{Mobility.normalize_locale(locale)}", as: :string, label: "Name (#{locale.upcase})"
            f.input "slogan_#{Mobility.normalize_locale(locale)}", as: :string, label: "Slogan (#{locale.upcase})"
          end
        end
      end
      tab "Events" do
        f.inputs do
          f.has_many :events, allow_destroy: true, heading: false do |event|
            event.input :id, as: :hidden
            event.input :eventable_id, as: :hidden, input_html: { value: resource.id }
            event.input :eventable_type, as: :hidden, input_html: { value: resource.class.name }
            event.input :label
            event.input :start_day
            event.input :end_day
            event.input :start_time
            event.input :end_time
            event.input :active
          end
        end
      end
    end
    f.actions
  end
end
