# frozen_string_literal: true

ActiveAdmin.register Ahoy::Event do
  menu parent: "analytics", priority: 2, label: "Events"

  actions :index, :show
  config.sort_order = "time_desc"

  scope :all, default: true
  scope("Security") { |events| events.where(name: AdminSecurityTracking::SECURITY_EVENT_NAMES) }
  scope("Public site") { |events| events.where(visit_id: Ahoy::Visit.public_site.select(:id)) }
  scope("Admin site") { |events| events.where(visit_id: Ahoy::Visit.admin_site.select(:id)) }

  includes :visit, :user

  filter :name
  filter :time
  filter :visit
  filter :user_type, as: :select, collection: [ "AdminUser", "User" ]

  index do
    id_column
    column :name
    column :time
    column :visit do |event|
      if event.visit
        link_to event.visit_id, admin_ahoy_visit_path(event.visit)
      end
    end
    column :user_type
    column("User") { |event| event.admin_user&.name || event.site_user&.name }
    column :properties do |event|
      truncate(event.properties.to_json, length: 80)
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :time
      row :visit do |event|
        if event.visit
          link_to "##{event.visit_id}", admin_ahoy_visit_path(event.visit)
        end
      end
      row :user_type
      row("Admin user") { |event| event.admin_user }
      row("Site user") { |event| event.site_user }
      row :properties do |event|
        pre JSON.pretty_generate(event.properties.presence || {})
      end
    end
  end
end
