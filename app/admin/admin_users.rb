ActiveAdmin.register AdminUser do
  menu priority: 5

  # Specify parameters which should be permitted for assignment
  permit_params %i[email encrypted_password reset_password_token reset_password_sent_at remember_created_at first_name last_name title bio username avatar language_preference active]
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

  member_action :delete_avatar, method: :get do
    resource.avatar.purge
    redirect_to admin_admin_user_path(params[:id]), notice: "Your avatar has been removed."
  end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :email
  filter :encrypted_password
  filter :reset_password_token
  filter :reset_password_sent_at
  filter :remember_created_at
  filter :first_name
  filter :last_name
  filter :title
  filter :bio
  filter :username
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :title
    column :bio
    column :username
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :email
      row :first_name
      row :last_name
      row :title
      row :bio
      row :username
      row :created_at
      row :updated_at
    end
  end

  form partial: "form"

  # form do |f|
  #   # f.template.render partial: "admin/restaurants/products/table", locals: { restaurant: resource }
  #   f.template.render partial: "form", locals: { resource: self, f: f }
  #   # render partial: "form", locals: { resource: resource, f: f }
  # end
end
