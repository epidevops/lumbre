Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  if Flipper.enabled?(:enable_admin_locale)
    scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
      ActiveAdmin.routes(self)
    end
  else
    ActiveAdmin.routes(self)
  end

  authenticate :admin_user, lambda { |admin_user| admin_user.has_role?(:super_admin) } do
    mount Blazer::Engine, at: "blazer", as: :mount_blazer
    mount ExceptionTrack::Engine, at: "/exception-track", as: "mount_exception_track"
    mount Flipper::UI.app(Flipper), at: "/flipper", as: "mount_flipper"
    mount LetterOpenerWeb::Engine, at: "/letter-opener", as: :mount_letter_opener_web
    mount SolidLitequeen::Engine, at: "/litequeen", as: :mount_solid_litequeen
    mount MissionControl::Jobs::Engine, at: "/jobs", as: :mount_mission_control_jobs
    mount Lookbook::Engine, at: "/lookbook", as: :mount_lookbook
    mount ActiveStorageDashboard::Engine, at: "/active-storage-dashboard", as: :mount_active_storage_dashboard
  end

  # direct :fresh_admin_user_avatar do |admin_user, options|
  #   route_for :avatar_admin_admin_user, admin_user.avatar_token, v: admin_user.updated_at.to_fs(:number)
  # end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    if Flipper.enabled?(:sign_in) && Flipper.enabled?(:sign_up)
      devise_for :users, module: "users", path: "", path_names: { sign_in: "login", sign_out: "logout", sign_up: "register" }
    end
    root "static#index"
    namespace :static do
      resources :contacts, only: [ :create ]
      resources :subscriptions, only: [ :create ]
    end

    resources :todos do
      member do
        patch :move
      end
    end
  end

  # authenticate :user, lambda { |u| u.present? } do
  # mount ExceptionTrack::Engine, at: "/exception-track", as: "mount_exception_track"
  # mount Flipper::UI.app(Flipper), at: "/flipper", as: "mount_flipper"
  # mount LetterOpenerWeb::Engine, at: "/letter_opener", as: :mount_letter_opener_web
  # mount SolidLitequeen::Engine, at: "/litequeen", as: :mount_solid_litequeen_dev
  # mount MissionControl::Jobs::Engine, at: "/jobs", as: :mount_mission_control_jobs
  # mount Lookbook::Engine, at: "/lookbook", as: :mount_lookbook
  # end

  match "*unmatched", to: "application#route_not_found", via: :all
end
