ActiveAdmin.register AdminUser do
  menu parent: "administration", priority: 1

  # Specify parameters which should be permitted for assignment
  permit_params :first_name, :last_name, :title, :bio,
                :active, :username, :email, :encrypted_password, # :password, :password_confirmation,
                :reset_password_token, :reset_password_sent_at, :remember_created_at,
                :password, :password_confirmation,
                :preferred_language, :created_at, :updated_at,
                :avatar,
                :otp_secret, :otp_backup_codes, :consumed_timestep, :otp_required_for_login, :otp_attempt,
                addresses_attributes: %i[id label address address_line_1 address_line_2 city state zip country time_zone url default active _destroy],
                emails_attributes: %i[id label email default active _destroy],
                phones_attributes: %i[id label phone default active _destroy],
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

  action_item :otp_toggle, only: %i[edit], priority: 2 do
    if resource.otp_required_for_login?
      link_to t("active_admin.otp.admin_users.disable_otp"), otp_disable_admin_admin_user_path(resource), method: :get,
              confirm: t("active_admin.otp.admin_users.disable_confirm"),
              class: "action-item-button btn-danger"
    else
      link_to t("active_admin.otp.admin_users.enable_otp"), "#",
              class: "action-item-button btn-primary",
              data: { modal_target: "otp-setup-modal", modal_show: "otp-setup-modal" }
    end
  end

  member_action :otp_disable, method: :get do
    resource.update(otp_required_for_login: false, otp_secret: nil, otp_backup_codes: nil, consumed_timestep: 0)
    redirect_to edit_admin_admin_user_path(resource), notice: t("active_admin.otp.admin_users.disabled_notice")
  end


  action_item :otp_generate_new_backup_codes, only: %i[edit], priority: 1 do
    if resource.otp_required_for_login?
      link_to t("active_admin.otp.admin_users.generate_new_backup_codes"), otp_generate_new_backup_codes_admin_admin_user_path(resource), method: :get,
                class: "action-item-button btn-primary"
    end
  end

  member_action :otp_generate_new_backup_codes, method: :get do
    backup_codes = resource.generate_otp_backup_codes!
    resource.save!

    # Store backup codes in flash for one-time display
    flash[:otp_backup_codes] = backup_codes
    redirect_to edit_admin_admin_user_path(resource), notice: t("active_admin.otp.admin_users.new_backup_codes_notice")
  end

  controller do
    def update
      # Handle MFA setup verification
      if params[:admin_user] && params[:admin_user][:otp_required_for_login] == "true" && params[:admin_user][:otp_attempt].present?
        verification_code = params[:admin_user][:otp_attempt]
        temp_otp_secret = params[:admin_user][:otp_secret]

        # Set the temp secret for verification (don't save yet)
        resource.otp_secret = temp_otp_secret

        # Verify OTP code using devise-two-factor validation
        if resource.validate_and_consume_otp!(verification_code)
          # Enable OTP and save the secret
          resource.update!(otp_required_for_login: true, otp_secret: temp_otp_secret)

          # Generate backup codes if supported
          if resource.respond_to?(:generate_otp_backup_codes!)
            backup_codes = resource.generate_otp_backup_codes!
            resource.save!

            # Store backup codes in flash for one-time display
            flash[:otp_backup_codes] = backup_codes
          end

          redirect_to edit_admin_admin_user_path(resource), notice: t("active_admin.otp.admin_users.enabled_notice")
        else
          # Don't save anything if validation failed
          resource.reload # Reset any changes
          flash[:alert] = t("active_admin.otp.admin_users.verification_error")
          redirect_to edit_admin_admin_user_path(resource)
        end
      else
        # Regular update
        super
      end
    end
  end

  member_action :delete_avatar, method: :get do
    resource.avatar.purge
    redirect_to admin_admin_user_path(params[:id]), notice: "Your avatar has been removed."
  end

  member_action :switch_language, method: :get do
    resource.update(preferred_language: params[:preferred_language])

    if request.referer.present?
      referer_params = Rails.application.routes.recognize_path(URI.parse(request.referer).path)
      redirect_to url_for(referer_params.merge(locale: params[:preferred_language]))
    else
      redirect_to admin_dashboard_path(locale: params[:preferred_language])
    end
  rescue ActionController::RoutingError
    redirect_to admin_dashboard_path(locale: params[:preferred_language])
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
  filter :otp_required_for_login

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
    column :otp_required_for_login
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
              image_tag(rails_blob_path(admin_user.avatar_thumb), class: "rounded-full", alt: "Admin avatar")
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
      row :otp_required_for_login
    end
  end

  form partial: "form"
end
