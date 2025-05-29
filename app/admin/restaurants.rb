ActiveAdmin.register Restaurant do
  menu priority: 2

  # Specify parameters which should be permitted for assignment
  permit_params :name, :slogan, :hero_text, :about_text, :active, :primary,
  *I18n.available_locales.map { |locale| "name_#{Mobility.normalize_locale(locale)}" },
  *I18n.available_locales.map { |locale| "slogan_#{Mobility.normalize_locale(locale)}" },
  *I18n.available_locales.map { |locale| "hero_text_#{Mobility.normalize_locale(locale)}" },
  *I18n.available_locales.map { |locale| "about_text_#{Mobility.normalize_locale(locale)}" },
  socials_attributes: %i[id socialable_type socialable_id name url icon _destroy],
  addresses_attributes: %i[id addressable_type addressable_id label address url active _destroy],
  phones_attributes: %i[id phoneable_type phoneable_id label phone active _destroy],
  emails_attributes: %i[id emailable_type emailable_id label email active _destroy],
  events_attributes: %i[id eventable_type eventable_id label start_day end_day start_time end_time active _destroy],
  products_attributes: %i[id productable_type productable_id title description price discount_percent recommended recommended_text position active options _destroy],
  schedules_attributes: %i[id scheduleable_type scheduleable_id name active capacity exclude_lunch_time beginning_of_week time_zone _destroy]

  controller do
    def update
      with_blocking_on_primary_restaurant do
        super
      end
    end

    def destroy
      with_blocking_on_primary_restaurant do
        super
      end
    end

    private

    def with_blocking_on_primary_restaurant
      if resource.primary
        flash[:alert] = "The primary restaurant cannot be modified."
        redirect_back fallback_location: admin_restaurants_path
      else
        yield
      end
    end
  end

  member_action :toggle_product_active, method: :post do
    product = Product.find(params[:id])
    resource = product.productable
    product.update(active: !product.active)
    # head :ok
    redirect_to edit_admin_restaurant_path(resource), notice: "Product #{product.active ? 'activated' : 'deactivated'} successfully"
  end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :name
  filter :slogan
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :name
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :name
      row :slogan
      row :hero_text
      row :about_text
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
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
            f.input "hero_text_#{Mobility.normalize_locale(locale)}", as: :text, label: "Hero Text (#{locale.upcase})"
            f.input "about_text_#{Mobility.normalize_locale(locale)}", as: :text, label: "About Text (#{locale.upcase})"
          end
        end
      end

      tab "Socials" do
        f.inputs do
          f.has_many :socials, allow_destroy: true, heading: false do |social|
            social.input :id, as: :hidden
            social.input :socialable_id, as: :hidden, input_html: { value: resource.id }
            social.input :socialable_type, as: :hidden, input_html: { value: resource.class.name }
            social.input :name
            social.input :url
            social.input :icon
            social.input :active
          end
        end
      end
      tab "Addresses" do
        f.inputs do
          f.has_many :addresses, allow_destroy: true, heading: false do |address|
            address.input :id, as: :hidden
            address.input :addressable_id, as: :hidden, input_html: { value: resource.id }
            address.input :addressable_type, as: :hidden, input_html: { value: resource.class.name }
            address.input :label
            address.input :address
            address.input :url
            address.input :active
          end
        end
      end
      tab "Phones" do
        f.inputs do
          f.has_many :phones, allow_destroy: true, heading: false do |phone|
            phone.input :id, as: :hidden
            phone.input :phoneable_id, as: :hidden, input_html: { value: resource.id }
            phone.input :phoneable_type, as: :hidden, input_html: { value: resource.class.name }
            phone.input :label
            phone.input :phone
            phone.input :active
          end
        end
      end
      tab "Emails" do
        f.inputs do
          f.has_many :emails, allow_destroy: true, heading: false do |email|
            email.input :id, as: :hidden
            email.input :emailable_id, as: :hidden, input_html: { value: resource.id }
            email.input :emailable_type, as: :hidden, input_html: { value: resource.class.name }
            email.input :label
            email.input :email
            email.input :active
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
      tab "Products" do
        f.template.render partial: "admin/restaurants/products/table", locals: { restaurant: resource }
      end
      tab "Schedules" do
        f.inputs do
          f.has_many :schedules, allow_destroy: true, heading: false do |schedule|
            schedule.input :id, as: :hidden
            schedule.input :scheduleable_id, as: :hidden, input_html: { value: resource.id }
            schedule.input :scheduleable_type, as: :hidden, input_html: { value: resource.class.name }
            schedule.input :name
            schedule.input :active
            schedule.input :capacity
            schedule.input :exclude_lunch_time
            schedule.input :beginning_of_week
            schedule.input :time_zone
          end
        end
      end
    end
    f.actions
  end
end
