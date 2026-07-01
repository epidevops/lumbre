require "test_helper"

class ActiveAdminCatalogRegistryTest < ActiveSupport::TestCase
  test "discovers model resources from namespace registry" do
    names = ActiveAdminCatalogRegistry.model_resources.map { |resource| resource.resource_class.name }

    assert_includes names, "Restaurant"
    assert_includes names, "Permission"
    assert_not_includes names, "ActiveAdmin::Comment"
  end

  test "discovers registered pages" do
    page_names = ActiveAdminCatalogRegistry.pages.map(&:name)

    assert_includes page_names, "Dashboard"
    assert_includes page_names, "Developer Tools"
  end

  test "maps authorization actions from defined and derived admin actions" do
    restaurant_entry = ActiveAdminCatalogRegistry.sorted_entries.find do |entry|
      entry.resource_class&.name == "Restaurant"
    end
    schedule_entry = ActiveAdminCatalogRegistry.sorted_entries.find do |entry|
      entry.resource_class&.name == "Schedule"
    end

    restaurant_actions = ActiveAdminCatalogRegistry.authorization_actions_for(restaurant_entry)
    schedule_actions = ActiveAdminCatalogRegistry.authorization_actions_for(schedule_entry)

    assert_includes restaurant_actions, "index"
    assert_includes restaurant_actions, "destroy"
    assert_includes restaurant_actions, "destroy_all"
    assert_includes restaurant_actions, "filter"

    assert_includes schedule_actions, "batch_actions"
  end

  test "maps collection actions into authorization actions" do
    product_entry = ActiveAdminCatalogRegistry.sorted_entries.find do |entry|
      entry.resource_class&.name == "Product"
    end
    access_resource_entry = ActiveAdminCatalogRegistry.sorted_entries.find do |entry|
      entry.resource_class&.name == "AccessResource"
    end

    product_actions = ActiveAdminCatalogRegistry.authorization_actions_for(product_entry)
    access_resource_actions = ActiveAdminCatalogRegistry.authorization_actions_for(access_resource_entry)

    assert_includes product_actions, "ca_update_positions"
    assert_includes access_resource_actions, "ca_sync_catalog"
  end

  test "captures member actions and custom action items for admin users" do
    entry = ActiveAdminCatalogRegistry.entries.find do |item|
      item.resource_class&.name == "AdminUser"
    end

    member_names = entry.member_actions.map(&:name)
    assert_includes member_names, "otp_disable"
    assert_includes member_names, "otp_generate_new_backup_codes"
    assert_includes member_names, "delete_avatar"
    assert_includes member_names, "switch_language"

    custom_items = entry.action_items.select(&:custom).map(&:name)
    assert_includes custom_items, "otp_toggle"
    assert_includes custom_items, "otp_generate_new_backup_codes"

    assert entry.csv_configured
  end

  test "builds navigation menu keys from pages and menu parents" do
    keys = ActiveAdminCatalogRegistry.navigation_menu_keys

    assert_includes keys.keys, "dashboard"
    assert_includes keys.keys, "application"
    assert_includes keys.keys, "administration"
    assert_includes keys.keys, "analytics"
    assert_equal keys.keys, keys.keys.sort
  end

  test "sorts entries by navigation, pages before models, then alphabetically" do
    sorted = ActiveAdminCatalogRegistry.sorted_entries
    nav_parents = sorted.map(&:menu_parent).map(&:to_s)

    assert_equal nav_parents, nav_parents.sort_by(&:downcase)

    sorted.group_by(&:menu_parent).each_value do |group|
      pages, models = group.partition { |entry| entry.kind == :page }

      assert_equal pages.map(&:label), pages.map(&:label).sort_by(&:downcase)
      assert_equal models.map(&:label), models.map(&:label).sort_by(&:downcase)
      assert pages.empty? || models.empty? || group.index(pages.first) < group.index(models.first)
    end
  end
end
