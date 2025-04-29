ActiveAdmin.register AdminUser do
  menu priority: 5

  # Specify parameters which should be permitted for assignment
  permit_params %i[email encrypted_password reset_password_token reset_password_sent_at remember_created_at first_name last_name title bio username avatar]

  # or consider:
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :name, :title, :bio]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
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
    column :encrypted_password
    column :reset_password_token
    column :reset_password_sent_at
    column :remember_created_at
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
      row :encrypted_password
      row :reset_password_token
      row :reset_password_sent_at
      row :remember_created_at
      row :first_name
      row :last_name
      row :title
      row :bio
      row :username
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  # form do |f|
  #   f.semantic_errors(*f.object.errors.attribute_names)
  #   f.inputs do
  #     f.input :avatar, as: :image_attachment, default_image: "default-avatar.svg"
  #     if resource.avatar.attached?
  #       div style: "display: none;" do
  #         link_to "Delete Avatar", delete_avatar_admin_admin_user_path, class: "image-attachment-delete-file-admin-user-avatar"
  #       end
  #     end
  #     f.input :email
  #     f.input :encrypted_password
  #     f.input :reset_password_token
  #     f.input :reset_password_sent_at
  #     f.input :remember_created_at
  #     f.input :first_name
  #     f.input :last_name
  #     f.input :title
  #     f.input :bio
  #     f.input :username
  #   end
  #   f.actions
  # end
  # form do |f|
  #   render 'form', context: self, f:
  # end

  form do |f|
    f partial: "form", locals: { context: self, f: }
  end
end
