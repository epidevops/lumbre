# Syncs the access control catalog from the Active Admin namespace registry.
class AccessControlCatalog
  class << self
    def sync!
      sync_access_resources!
      sync_page_access_resources!
      sync_navigation_authorizations!
      sync_resource_authorizations!
      sync_page_authorizations!
    end

    def navigation_menu_keys
      ActiveAdminCatalogRegistry.navigation_menu_keys
    end

    def sync_access_resources!
      ActiveAdminCatalogRegistry.model_resources.each do |resource|
        upsert_access_resource!(
          kind: "model",
          resource_class: resource.resource_class.name,
          label: resource.resource_class.model_name.human,
          menu_parent: menu_parent_for(resource)
        )
      end
    end

    def sync_page_access_resources!
      ActiveAdminCatalogRegistry.pages.each do |page|
        upsert_access_resource!(
          kind: "page",
          resource_class: ActiveAdminCatalogRegistry.page_resource_class_for(page),
          label: page.name,
          menu_parent: menu_parent_for(page)
        )
      end
    end

    def sync_navigation_authorizations!
      access_type = AccessType.navigation.first!
      navigation_menu_keys.each do |key, label|
        upsert_authorization!(
          access_type:,
          key:,
          label:,
          access_resource: nil
        )
      end
    end

    def sync_resource_authorizations!
      access_type = AccessType.resources.first!
      ActiveAdminCatalogRegistry.sorted_entries.select { |entry| entry.kind == :model }.each do |entry|
        access_resource = AccessResource.find_by!(resource_class: entry.resource_class.name)
        sync_authorizations_for_entry!(access_type:, access_resource:, entry:)
      end
    end

    def sync_page_authorizations!
      access_type = AccessType.pages.first!
      ActiveAdminCatalogRegistry.sorted_entries.select { |entry| entry.kind == :page }.each do |entry|
        page = ActiveAdminCatalogRegistry.pages.find { |resource| resource.name == entry.label }
        next unless page

        access_resource = AccessResource.find_by!(resource_class: ActiveAdminCatalogRegistry.page_resource_class_for(page))
        sync_authorizations_for_entry!(access_type:, access_resource:, entry:)
      end
    end

    private

      def sync_authorizations_for_entry!(access_type:, access_resource:, entry:)
        ActiveAdminCatalogRegistry.authorization_actions_for(entry).each do |action|
          upsert_authorization!(
            access_type:,
            key: "#{access_resource.key}_#{action}",
            label: "#{access_resource.label} — #{authorization_label(action)}",
            access_resource:,
            action:
          )
        end
      end

      def authorization_label(action)
        case action
        when /\Aba_(.+)\z/ then "Batch: #{::Regexp.last_match(1).humanize}"
        when /\Ama_(.+)\z/ then "Member: #{::Regexp.last_match(1).humanize}"
        when /\Aca_(.+)\z/ then "Collection: #{::Regexp.last_match(1).humanize}"
        when /\Aai_(.+)\z/ then "Action item: #{::Regexp.last_match(1).humanize}"
        else action.humanize
        end
      end

      def menu_parent_for(resource)
        ActiveAdminCatalogRegistry.menu_parent_for(resource)
      end

      def upsert_access_resource!(kind:, resource_class:, label:, menu_parent:)
        key = access_resource_key(kind:, resource_class:)
        AccessResource.find_or_initialize_by(resource_class:).tap do |access_resource|
          access_resource.key = key
          access_resource.label = label
          access_resource.menu_parent = menu_parent
          access_resource.kind = kind
          access_resource.source = "active_admin"
          access_resource.save!
        end
      end

      def access_resource_key(kind:, resource_class:)
        if kind == "page"
          resource_class.delete_prefix("ActiveAdmin::Page:")
        else
          resource_class.underscore.tr("/", "_")
        end
      end

      def upsert_authorization!(access_type:, key:, label:, access_resource: nil, action: nil)
        access_type.access_authorizations.find_or_initialize_by(key:).tap do |authorization|
          authorization.label = label
          authorization.access_resource = access_resource
          authorization.action = action
          authorization.save!
        end
      end
  end
end
