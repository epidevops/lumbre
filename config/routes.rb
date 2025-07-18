Rails.application.routes.draw do
  # Mount Active Storage routes outside of locale scope
  # mount ActiveStorage::Engine => "/rails/active_storage"

  # Active Admin Devise routes (outside locale scope to maintain AA defaults)


  scope "(/:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    devise_for :admin_users, ActiveAdmin::Devise.config.merge(
      controllers: ActiveAdmin::Devise.config[:controllers].merge(
        sessions: "admin_users/sessions"
      )
    )

    ActiveAdmin.routes(self)

    devise_scope :admin_user do
      get "admin/mfa", to: "admin_users/sessions/otp#challenge", as: :admin_user_otp_challenge
      post "admin/mfa", to: "admin_users/sessions/otp#verify", as: :admin_user_otp_verify
      delete "admin/mfa", to: "admin_users/sessions/otp#cancel", as: :admin_user_otp_cancel
    end
  end

  authenticate :admin_user, lambda { |admin_user| admin_user.super_admin? } do
    # Core admin tools - always available in production
    mount Blazer::Engine, at: "/blazer", as: :mount_blazer
    mount ExceptionTrack::Engine, at: "/exception-track", as: :mount_exception_track
    mount Flipper::UI.app(Flipper), at: "/flipper", as: :mount_flipper
    mount LetterOpenerWeb::Engine, at: "/letter-opener", as: :mount_letter_opener_web
    mount SolidLitequeen::Engine, at: "/litequeen", as: :mount_solid_litequeen
    mount MissionControl::Jobs::Engine, at: "/jobs", as: :mount_mission_control_jobs
    mount Lookbook::Engine, at: "/lookbook", as: :mount_lookbook
    mount ActiveStorageDashboard::Engine, at: "/active-storage-dashboard", as: :mount_active_storage_dashboard

    # Rails info routes - available for authenticated admin users
    if Rails.env.production?
      mount Rails::InfoController.action(:routes), at: "/rails/info/routes", as: :rails_info_routes
      mount Rails::InfoController.action(:properties), at: "/rails/info/properties", as: :rails_info_properties
      mount Rails::InfoController.action(:notes), at: "/rails/info/notes", as: :rails_info_notes
    end
  end

  # namespace :admin do
  #   resources :sections do
  #     member do
  #       post :toggle_active
  #     end
  #   end
  # end

  # direct :fresh_admin_user_avatar do |admin_user, options|
  #   route_for :avatar_admin_admin_user, admin_user.avatar_token, v: admin_user.updated_at.to_fs(:number)
  # end

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  scope "(/:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    begin
      if Flipper.enabled?(:user_sign_in) && Flipper.enabled?(:user_sign_up)
        devise_for :users, module: "users", path: "", path_names: { sign_in: "login", sign_out: "logout", sign_up: "register" }
      end
    rescue ActiveRecord::StatementInvalid, ActiveRecord::NoDatabaseError
      # Skip Flipper checks during database setup
    end
    root "static#index"
    namespace :static do
      resources :contacts, only: [ :create ]
      resources :subscriptions, only: [ :create ]
    end

    begin
      if Flipper.enabled?(:enable_admin_dev_tools)
        mount Blazer::Engine, at: "/dev/blazer", as: :mount_blazer_dev
        mount ExceptionTrack::Engine, at: "/dev/exception-track", as: :mount_exception_track_dev
        mount Flipper::UI.app(Flipper), at: "/dev/flipper", as: :mount_flipper_dev
        mount LetterOpenerWeb::Engine, at: "/dev/letter-opener", as: :mount_letter_opener_web_dev
        mount SolidLitequeen::Engine, at: "/dev/litequeen", as: :mount_solid_litequeen_dev
        mount MissionControl::Jobs::Engine, at: "/dev/jobs", as: :mount_mission_control_jobs_dev
        mount Lookbook::Engine, at: "/dev/lookbook", as: :mount_lookbook_dev
        mount ActiveStorageDashboard::Engine, at: "/dev/active-storage-dashboard", as: :mount_active_storage_dashboard_dev

        resources :todos do
          member do
            patch :move
          end
        end
      end
    rescue ActiveRecord::StatementInvalid, ActiveRecord::NoDatabaseError
      # Skip Flipper checks during database setup
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # match "*unmatched", to: "application#route_not_found", via: :all
end
