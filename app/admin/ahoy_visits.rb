# frozen_string_literal: true

ActiveAdmin.register Ahoy::Visit do
  menu parent: "analytics", priority: 1, label: "Visits"

  actions :index, :show
  config.sort_order = "started_at_desc"

  scope :all, default: true
  scope :public_site
  scope :admin_site

  includes :user

  filter :started_at
  filter :landing_page
  filter :referring_domain
  filter :browser
  filter :os
  filter :device_type
  filter :country
  filter :city
  filter :user_type, as: :select, collection: [ "AdminUser", "User" ]
  filter :ip

  index do
    id_column
    column :started_at
    column :landing_page do |visit|
      truncate(visit.landing_page.to_s, length: 60)
    end
    column :browser
    column :os
    column :device_type
    column :country
    column :user_type
    column("User") { |visit| visit.admin_user&.name || visit.site_user&.name }
    column("Events") { |visit| visit.events.count }
    actions
  end

  show do
    attributes_table do
      row :id
      row :started_at
      row :visit_token
      row :visitor_token
      row :landing_page
      row :referrer
      row :referring_domain
      row :browser
      row :os
      row :device_type
      row :platform
      row :country
      row :region
      row :city
      row :latitude
      row :longitude
      row :ip
      row :user_type
      row("Admin user") { |visit| visit.admin_user }
      row("Site user") { |visit| visit.site_user }
      row :utm_source
      row :utm_medium
      row :utm_campaign
      row :utm_term
      row :utm_content
      row :user_agent
    end

    panel "Events" do
      if resource.events.any?
        table_for resource.events.order(time: :desc) do
          column :id do |event|
            link_to event.id, admin_ahoy_event_path(event)
          end
          column :name
          column :time
          column :properties
        end
      else
        para "No events recorded for this visit."
      end
    end
  end
end
