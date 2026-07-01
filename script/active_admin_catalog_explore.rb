#!/usr/bin/env ruby
# frozen_string_literal: true

# Explore Active Admin namespace resources, pages, actions, and navigation.
# Usage: bin/rails runner script/active_admin_catalog_explore.rb

def print_list(label, items)
  return if items.blank?

  puts "  #{label}:"
  items.each do |item|
    puts "    - #{item.respond_to?(:to_h) ? item.to_h : item}"
  end
end

def print_entry(entry)
  puts "=" * 72
  puts "#{entry.kind.to_s.upcase} #{entry.resource_name}"
  puts "  label:           #{entry.label}"
  puts "  class:           #{entry.resource_class&.name || '-'}"
  puts "  menu_parent:     #{entry.menu_parent || '-'}"
  puts "  defined_actions: #{entry.defined_actions.join(', ')}"
  authorization_actions = ActiveAdminCatalogRegistry.authorization_actions_for(entry)
  puts "  authorization_actions: #{authorization_actions.join(', ')}"
  puts "  csv_configured:  #{entry.csv_configured}"

  print_list("batch_actions", entry.batch_actions)
  print_list("member_actions", entry.member_actions)
  print_list("collection_actions", entry.collection_actions)
  print_list("action_items", entry.action_items)
  print_list("filters", entry.filters)
end

ActiveAdminCatalogRegistry.sorted_entries
  .group_by(&:menu_parent)
  .sort_by { |menu_parent, _entries| menu_parent.to_s.downcase }
  .each do |menu_parent, entries|
    nav_label = menu_parent.present? ? menu_parent.humanize : "(root)"
    puts "#" * 72
    puts "NAVIGATION: #{nav_label}"
    puts "#" * 72

    entries.each { |entry| print_entry(entry) }
  end

puts "=" * 72
puts "Navigation menus:"
ActiveAdminCatalogRegistry.navigation_menu_keys.each do |key, label|
  puts "  #{key} => #{label}"
end
