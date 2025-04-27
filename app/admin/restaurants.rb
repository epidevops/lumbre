ActiveAdmin.register Restaurant do
  # Specify parameters which should be permitted for assignment
  permit_params :name, :slogan, :hero_text, :about_text, :enable_weekly_deals, :enable_meet_the_team, :enable_subscribe, :enable_gallery, :enable_testimonials, :active, :primary,
  socials_attributes: %i[id socialable_type socialable_id name url icon _destroy],
  addresses_attributes: %i[id addressable_type addressable_id label address url active _destroy],
  phones_attributes: %i[id phoneable_type phoneable_id label phone active _destroy],
  emails_attributes: %i[id emailable_type emailable_id label email active _destroy],
  events_attributes: %i[id eventable_type eventable_id label start_day end_day start_time end_time active _destroy],
  products_attributes: %i[id productable_type productable_id title description price discount_percent recommended recommended_text position active options _destroy]

  # or consider:
  #
  # permit_params do
  #   permitted = [:name, :about]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end


  member_action :toggle_product_active, method: :post do
    product = Product.find(params[:product_id])
    product.update(active: !product.active)
    redirect_to admin_restaurant_path(resource), notice: "Product #{product.active ? 'activated' : 'deactivated'} successfully"
  end

  member_action :update_product_position, method: :post do
    product = Product.find(params[:product_id])
    product.update(position: params[:position])
    redirect_to admin_restaurant_path(resource), notice: "Product position updated successfully"
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
          f.input :name
          f.input :slogan
          f.input :hero_text
          f.input :about_text
          f.input :active
          f.input :primary
        end
      end
      tab "Site Settings" do
        f.inputs do
          f.input :enable_weekly_deals
          f.input :enable_meet_the_team
          f.input :enable_subscribe
          f.input :enable_gallery
          f.input :enable_testimonials
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
    end
    f.actions
  end
end
