ActiveAdmin.register AdminUser do
  menu parent: "administration", priority: 1

  # Specify parameters which should be permitted for assignment
  permit_params :first_name, :last_name, :title, :bio,
                :active, :username, :email, :encrypted_password, # :password, :password_confirmation,
                :reset_password_token, :reset_password_sent_at, :remember_created_at,
                :otp_required_for_login, :otp_secret, :consumed_timestep,
                :password, :password_confirmation,
                :preferred_language, :created_at, :updated_at,
                :avatar,
                admin_users_roles_attributes: %i[id admin_user_id role_id _destroy],
                roles_attributes: %i[id name resource_id resource_type created_at updated_at _destroy]

  # permit_params %i[email encrypted_password reset_password_token reset_password_sent_at remember_created_at first_name last_name title bio username avatar preferred_language active]
  # preference_attributes: %i[id preferenceable_id preferenceable_type email_notifications sms_notifications mobile_push_notifications web_push_notifications language timezone theme]

  # controller do
  #   include ActiveStorage::Streaming
  #   include ActionView::Helpers::AssetUrlHelper

  #   rescue_from(ActiveSupport::MessageVerifier::InvalidSignature) { head :not_found }

  #   private
  #     SQUARE_WEBP_VARIANT = { resize_to_limit: [ 512, 512 ], format: :webp }

  #     def send_webp_blob_file(key)
  #       send_file ActiveStorage::Blob.service.path_for(key), content_type: "image/webp", disposition: :inline
  #     end

  #     def render_default_avatar
  #       send_file Rails.root.join("app/assets/images/default-admin-avatar.svg"), content_type: "image/svg+xml", disposition: :inline
  #     end

  #     def render_initials
  #       render formats: :svg
  #     end
  # end

  # member_action :delete_avatar, method: :delete do
  #   resource.avatar.purge
  #   redirect_to admin_admin_user_path(params[:id]), notice: "Your avatar has been removed."
  # end

  # member_action :avatar, method: :get do
  #   if stale?(etag: @user)
  #     expires_in 30.minutes, public: true, stale_while_revalidate: 1.week

  #     if current_admin_user.avatar.attached?
  #       avatar_variant = current_admin_user.avatar.variant(SQUARE_WEBP_VARIANT).processed
  #       send_webp_blob_file avatar_variant.key
  #     elsif current_admin_user.initials.present?
  #       render_initials
  #     else
  #       render_default_avatar
  #     end
  #   end
  # end

  # controller do
  #   skip_before_action :set_locale, only: %i[create update]
  # end

  action_item :two_factor, only: %i[edit show], priority: 1 do
    link_to "Two Factor", "#", class: "action-item-button"
  end

  member_action :delete_avatar, method: :get do
    resource.avatar.purge
    redirect_to admin_admin_user_path(params[:id]), notice: "Your avatar has been removed."
  end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :email
  filter :first_name
  filter :last_name
  filter :title
  filter :preferred_language
  filter :active

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :title
    column :preferred_language
    column :active
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row(:avatar) do |admin_user|
        div do
          if admin_user.avatar.attached?
            begin
              # image_tag(rails_blob_path(admin_user.avatar.variant(resize_to_limit: [100, 100]), only_path: true), class: "admin-avatar", alt: "Admin avatar")
              image_tag(rails_blob_path(admin_user.avatar_thumb), class: "admin-avatar", alt: "Admin avatar")
            rescue => e
              "Error loading avatar: #{e.message}"
            end
          else
            "No avatar"
          end
        end
      end
      row :email
      row :first_name
      row :last_name
      row :title
      row :preferred_language
      row :active
    end
  end

  form partial: "form"

  # form do |f|
  #   # f.template.render partial: "admin/restaurants/products/table", locals: { restaurant: resource }
  #   f.template.render partial: "form", locals: { resource: self, f: f }
  #   # render partial: "form", locals: { resource: resource, f: f }
  # end
end
