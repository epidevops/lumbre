# frozen_string_literal: true

ActiveAdmin.register Role do
  menu parent: "administration", priority: 2
  # menu parent: %w[administration security], label: proc { t :roles }

  permit_params :id, :name, :resource_type, :resource_id

  filter :id
  filter :name
  filter :resource_type
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column(:name) { |role| role.name.titleize }
    column("Resource Type") { |role| role.resource_type.presence || "Global Role" }
    column("Resource ID") { |role| role.resource_id.presence || "Global Role" }
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row(:name) { |role| role.name.titleize }
      row("Resource Type") { |role| role.resource_type.presence || "Global Role" }
      row("Resource ID") { |role| role.resource_id.presence || "Global Role" }
      row :created_at
      row :updated_at
    end
    # active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :id, input_html: { disabled: !f.object.new_record? }
      f.input :name, input_html: { disabled: !f.object.new_record? }
      f.input :resource_type, input_html: { disabled: !f.object.new_record? }
      f.input :resource_id, input_html: { disabled: !f.object.new_record? }
    end
    f.actions
  end
end
