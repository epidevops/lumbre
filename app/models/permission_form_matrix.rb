# Builds authorization rows and columns for the permission form matrix UI.
class PermissionFormMatrix
  attr_reader :permission, :access_type

  def initialize(permission, access_type)
    @permission = permission
    @access_type = access_type
  end

  def navigation?
    access_type.key == AccessType::NAVIGATION
  end

  def resources?
    access_type.key == AccessType::RESOURCES
  end

  def pages?
    access_type.key == AccessType::PAGES
  end

  def action_columns
    if navigation?
      [ "enabled" ]
    else
      dynamic_action_columns
    end
  end

  def rows
    if navigation?
      navigation_rows
    elsif pages?
      page_rows
    else
      resource_rows
    end
  end

  def grouped_resource_rows
    rows.group_by { |row| row[:menu_parent].presence || "(root)" }
        .sort_by { |menu_parent, _rows| menu_parent.to_s.downcase }
  end

  private

    def navigation_rows
      authorizations.map do |authorization|
        {
          key: authorization.key,
          label: authorization.label,
          menu_parent: nil,
          access_resource: nil,
          resource_scope: nil,
          cells: { "enabled" => authorization }
        }
      end
    end

    def resource_rows
      catalog_entries = ActiveAdminCatalogRegistry.sorted_entries.select { |entry| entry.kind == :model }
      authorizations_by_resource = authorizations.group_by(&:access_resource_id)

      catalog_entries.filter_map do |entry|
        access_resource = AccessResource.find_by(resource_class: entry.resource_class.name)
        next unless access_resource

        resource_authorizations = authorizations_by_resource[access_resource.id] || []
        cells = action_columns.index_with do |action|
          resource_authorizations.find { |authorization| authorization.action == action }
        end

        {
          key: access_resource.key,
          label: access_resource.label,
          menu_parent: entry.menu_parent,
          access_resource: access_resource,
          resource_scope: permission.resource_scope_for(access_resource),
          cells: cells
        }
      end
    end

    def page_rows
      catalog_entries = ActiveAdminCatalogRegistry.sorted_entries.select { |entry| entry.kind == :page }
      authorizations_by_resource = authorizations.group_by(&:access_resource_id)

      catalog_entries.filter_map do |entry|
        page = ActiveAdminCatalogRegistry.pages.find { |resource| resource.name == entry.label }
        next unless page

        access_resource = AccessResource.find_by(resource_class: ActiveAdminCatalogRegistry.page_resource_class_for(page))
        next unless access_resource

        page_authorizations = authorizations_by_resource[access_resource.id] || []
        cells = action_columns.index_with do |action|
          page_authorizations.find { |authorization| authorization.action == action }
        end

        {
          key: access_resource.key,
          label: access_resource.label,
          menu_parent: entry.menu_parent,
          access_resource: access_resource,
          resource_scope: nil,
          cells: cells
        }
      end
    end

    def dynamic_action_columns
      @dynamic_action_columns ||= authorizations.filter_map(&:action).uniq.sort_by do |action|
        ActiveAdminCatalogRegistry.action_sort_key(action)
      end
    end

    def authorizations
      @authorizations ||= access_type.access_authorizations.includes(:access_resource).order(:label).to_a
    end
end
