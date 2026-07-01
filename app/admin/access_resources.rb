ActiveAdmin.register AccessResource do
  menu parent: "administration", priority: 5, if: proc { current_admin_user.super_admin? }

  actions :index, :show

  filter :key
  filter :resource_class
  filter :menu_parent
  filter :source

  action_item :sync_catalog, only: :index, if: proc { current_admin_user.super_admin? } do
    link_to "Sync Catalog", sync_catalog_admin_access_resources_path, method: :post
  end

  collection_action :sync_catalog, method: :post do
    AccessControlCatalog.sync!
    redirect_to admin_access_resources_path, notice: "Access catalog synced from Active Admin."
  end

  index do
    id_column
    column :key
    column :label
    column :resource_class
    column :menu_parent
    column :source
    column(:authorizations) { |access_resource| access_resource.access_authorizations.count }
    actions
  end

  show do
    attributes_table_for(resource) do
      row :key
      row :label
      row :resource_class
      row :menu_parent
      row :source
      row :created_at
      row :updated_at
    end

    panel "Authorizations" do
      table_for resource.access_authorizations.order(:action) do
        column :key
        column :label
        column :action
      end
    end
  end
end
