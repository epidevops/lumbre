# Discovers Active Admin resources, pages, actions, and navigation from the
# loaded namespace registry.
class ActiveAdminCatalogRegistry
  DEFAULT_ACTION_ITEMS = %w[new edit destroy].freeze

  Entry = Data.define(
    :kind,
    :resource_name,
    :resource_class,
    :label,
    :menu_parent,
    :defined_actions,
    :batch_actions,
    :member_actions,
    :collection_actions,
    :action_items,
    :filters,
    :csv_configured
  )

  BatchActionDetail = Data.define(:sym, :title, :confirm, :form_fields)
  MemberActionDetail = Data.define(:name, :http_verb)
  CollectionActionDetail = Data.define(:name, :http_verb)
  ActionItemDetail = Data.define(:name, :only, :except, :priority, :custom)

  SKIPPED_RESOURCE_CLASSES = %w[ActiveAdmin::Comment].freeze

  class << self
    def load!
      ActiveAdmin.application.load!
    end

    def namespace
      load!
      ActiveAdmin.application.namespaces[:admin]
    end

    def resources
      namespace.resources
    end

    def resource_names
      resources.map { |resource| resource.resource_name.to_s }
    end

    def model_resources
      resources.select do |resource|
        resource.is_a?(ActiveAdmin::Resource) &&
          resource.resource_class < ActiveRecord::Base &&
          SKIPPED_RESOURCE_CLASSES.exclude?(resource.resource_class.name)
      end
    end

    def pages
      resources.select { |resource| resource.is_a?(ActiveAdmin::Page) }
    end

    def entries
      model_resources.map { |resource| build_model_entry(resource) } +
        pages.map { |resource| build_page_entry(resource) }
    end

    def sorted_entries
      entries.sort_by { |entry| entry_sort_key(entry) }
    end

    def navigation_menu_keys
      keys = {}
      pages.each do |page|
        keys[navigation_key_for(page)] = page.name
      end

      model_resources.each do |resource|
        parent = menu_parent_for(resource)
        next if parent.blank?

        keys[parent.to_s] ||= parent.to_s.humanize
      end

      keys.sort_by { |key, _label| key }.to_h
    end

    def menu_parent_for(resource)
      menu_parent_from_options(resource)
    end

    def authorization_actions_for(entry)
      case entry.kind
      when :page
        page_authorization_actions(entry)
      when :model
        resource_authorization_actions(entry)
      else
        []
      end
    end

    def page_resource_class_for(page)
      AccessResource.page_resource_class(page)
    end

    def action_sort_key(action)
      authorization_action_sort_key(action)
    end

    private

      def resource_authorization_actions(entry)
        actions = entry.defined_actions.map(&:to_s) & AccessAuthorization::STANDARD_ACTIONS
        batch_syms = entry.batch_actions.map(&:sym)

        actions << "destroy_all" if batch_syms.include?("destroy")
        actions << "batch_actions" if batch_syms.any? { |sym| sym != "destroy" }
        batch_syms.each { |sym| actions << "ba_#{sym}" }
        entry.member_actions.each { |member_action| actions << "ma_#{member_action.name}" }
        entry.collection_actions.each { |collection_action| actions << "ca_#{collection_action.name}" }
        custom_action_items_for(entry).each { |action_item| actions << "ai_#{action_item.name}" }
        actions << "index_download" if entry.csv_configured
        actions << "filter" if entry.filters.any?
        actions.uniq.sort_by { |action| authorization_action_sort_key(action) }
      end

      def page_authorization_actions(entry)
        entry.defined_actions.map(&:to_s).uniq.sort
      end

      def custom_action_items_for(entry)
        covered = entry.defined_actions.map(&:to_s).to_set
        covered.merge(entry.member_actions.map(&:name))
        covered.merge(entry.collection_actions.map(&:name))
        covered.merge(%w[new edit destroy create update show index])

        entry.action_items.select(&:custom).reject { |action_item| covered.include?(action_item.name) }
      end

      def authorization_action_sort_key(action)
        standard_index = AccessAuthorization::STANDARD_ACTIONS.index(action)
        return [ 0, standard_index ] if standard_index

        prefix_order = AccessAuthorization::ACTION_PREFIXES.index { |prefix| action.start_with?(prefix) } || 99
        [ 1, prefix_order, action ]
      end

      def build_model_entry(resource)
        Entry.new(
          kind: :model,
          resource_name: resource.resource_name.to_s,
          resource_class: resource.resource_class,
          label: resource.resource_class.model_name.human,
          menu_parent: menu_parent_for(resource),
          defined_actions: resource.defined_actions.map(&:to_s),
          batch_actions: batch_action_details(resource),
          member_actions: member_action_details(resource),
          collection_actions: collection_action_details(resource),
          action_items: action_item_details(resource),
          filters: resource.filters.keys.map(&:to_s),
          csv_configured: csv_configured?(resource)
        )
      end

      def build_page_entry(page)
        Entry.new(
          kind: :page,
          resource_name: page.resource_name.to_s,
          resource_class: nil,
          label: page.name,
          menu_parent: menu_parent_for(page),
          defined_actions: [ "index" ],
          batch_actions: [],
          member_actions: [],
          collection_actions: [],
          action_items: action_item_details(page),
          filters: [],
          csv_configured: false
        )
      end

      def batch_action_details(resource)
        return [] unless resource.is_a?(ActiveAdmin::Resource)

        resource.batch_actions.map do |batch_action|
          options = batch_action_options(batch_action)
          BatchActionDetail.new(
            sym: batch_action.sym.to_s,
            title: batch_action_title(batch_action, resource),
            confirm: batch_action.confirm.present?,
            form_fields: Array(options[:form]).map { |field| field.to_s }
          )
        end
      end

      def member_action_details(resource)
        return [] unless resource.respond_to?(:member_actions)

        resource.member_actions.map do |member_action|
          MemberActionDetail.new(
            name: member_action.name.to_s,
            http_verb: member_action.http_verb.to_s
          )
        end
      end

      def collection_action_details(resource)
        return [] unless resource.respond_to?(:collection_actions)

        resource.collection_actions.map do |collection_action|
          CollectionActionDetail.new(
            name: collection_action.name.to_s,
            http_verb: collection_action.http_verb.to_s
          )
        end
      end

      def action_item_details(resource)
        return [] unless resource.respond_to?(:action_items)

        resource.action_items.map do |action_item|
          options = action_item_options(action_item)
          ActionItemDetail.new(
            name: action_item.name.to_s,
            only: Array(options[:only]).map(&:to_s).presence,
            except: Array(options[:except]).map(&:to_s).presence,
            priority: action_item.priority,
            custom: !DEFAULT_ACTION_ITEMS.include?(action_item.name.to_s)
          )
        end
      end

      def csv_configured?(resource)
        resource.instance_variable_defined?(:@csv_builder) &&
          resource.instance_variable_get(:@csv_builder).present?
      end

      def batch_action_options(batch_action)
        batch_action.instance_variable_get(:@options) || {}
      end

      def batch_action_title(batch_action, resource)
        title = batch_action.title
        return title if title.is_a?(String)

        if title.is_a?(Proc)
          resource.instance_exec(&title)
        else
          batch_action.sym.to_s.humanize
        end
      rescue StandardError
        batch_action.sym.to_s.humanize
      end

      def action_item_options(action_item)
        action_item.instance_variable_get(:@options) || {}
      end

      def menu_parent_from_options(resource)
        options = resource.menu_item_options
        return if options == false || !options.is_a?(Hash)

        options[:parent]&.to_s
      end

      def navigation_key_for(page)
        page.resource_name.param_key.to_s
      end

      def entry_sort_key(entry)
        [
          entry.menu_parent.to_s.downcase,
          entry.kind == :page ? 0 : 1,
          entry.label.downcase
        ]
      end
  end
end
