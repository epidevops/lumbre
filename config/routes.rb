Rails.application.routes.draw do
  resources :todos
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    devise_for :users, module: "users", path: "", path_names: { sign_in: "login", sign_out: "logout", sign_up: "register" }
    root "static#index"
    namespace :static do
      resources :contacts, only: [ :create ]
      resources :subscriptions, only: [ :create ]
    end
  end


    # authenticate :user, lambda { |u| u.present? } do
    mount ExceptionTrack::Engine, at: "/exception-track", as: "mount_exception_track"
    mount Flipper::UI.app(Flipper), at: "/flipper", as: "mount_flipper"
    mount LetterOpenerWeb::Engine, at: "/letter_opener", as: :mount_letter_opener_web
    mount SolidLitequeen::Engine, at: "/litequeen", as: :mount_solid_litequeen
    mount MissionControl::Jobs::Engine, at: "/jobs", as: :mount_mission_control_jobs
    mount Lookbook::Engine, at: "/lookbook", as: :mount_lookbook
  # end
end
