# frozen_string_literal: true

ActiveAdmin.register Schedule do
  menu parent: "application", priority: 4
  # menu parent: 'organization', label: proc { t :schedules }

  # config.remove_action_item(:new)

  permit_params :active, :beginning_of_week, :capacity, :company_id, :exclude_lunch_time, :lunch_hour_start,
                :lunch_hour_end, :name, :scheduleable_id, :scheduleable_type, :start_date, :time_zone, { user_types: [] },
                rules_attributes: [ :id, :name, :rule_type, :frequency_units, :frequency, { days_of_week: [] },
                                   :start_date, :end_date, :rule_hour_start, :rule_hour_end, :_destroy ]

  includes :rules

  controller do
    before_action :set_beginning_of_week, only: [ :show ]
    before_action :load_events, only: [ :show ]

    def set_beginning_of_week
      Date.beginning_of_week = resource.beginning_of_week.to_sym
    end

    def create
      create! do |format|
        format.html { redirect_to edit_admin_schedule_path resource.id, anchor: :rules }
      end
    end

    def load_events
      if params[:start_date]
        start_date = params[:start_date].to_date.beginning_of_month - params[:start_date].to_date.beginning_of_month.wday
        @events ||= resource.get_scheduled_events.select { |item| item.start_date.to_date.between?(start_date.beginning_of_week, (start_date + 35.days).end_of_week) }
      else
        @events ||= resource.get_scheduled_events
      end
    end
  end

  batch_action :toggle_active do |ids|
    batch_action_collection.find(ids).each do |schedule|
      schedule.active = !schedule.active
      schedule.save
    end
    redirect_to collection_path, notice: "The schedules active status has been toggled."
  end

  batch_action :clone, confirm: "Close time rules included by default, check box if you want to omit.", form: { Exclude: :checkbox } do |ids, inputs|
    batch_action_collection.find(ids).each do |schedule|
      @schedule = schedule.dup
      @schedule.name = "UPDATE ME..."
      @schedule.active = false
      @schedule.save
      if inputs["Exclude"] == "on"
        @schedule.rules << schedule.rules.inclusion.map(&:dup)
      else
        @schedule.rules << schedule.rules.map(&:dup)
      end
    end
    redirect_to collection_path, notice: "The schedules have been cloned."
  end

  batch_action :add_holidays do |ids|
    batch_action_collection.find(ids).each do |schedule|
      schedule.add_holidays(schedule)
    end
    redirect_to collection_path, notice: "The schedules have had holidays added."
  end

  batch_action :remove_holidays do |ids|
    batch_action_collection.find(ids).each do |schedule|
      schedule.remove_holidays(schedule)
    end
    redirect_to collection_path, notice: "The schedules have had holidays removed."
  end

  batch_action :add_close_times, form: { "Start Date": :datepicker, "End Date": :datepicker, "Start Time": :text, "End Time": :text } do |ids, inputs|
    batch_action_collection.find(ids).each do |schedule|
      if inputs["Start Date"].present?
        schedule.rules.create(rule_type: "exclusion", name: "Close Time Rule", start_date: inputs["Start Date"], end_date: inputs["End Date"].blank? ? nil : inputs["End Date"], rule_hour_start: inputs["Start Time"].blank? ? "" : Time.parse(inputs["Start Time"]).strftime("%H:%M"), rule_hour_end: inputs["End Time"].blank? ? "" : Time.parse(inputs["End Time"]).strftime("%H:%M"))
      end
    end
    if inputs["Start Date"].present?
      redirect_to collection_path, notice: "The schedules have been updated with close time rules."
    else
      redirect_to collection_path, alert: "Start Date is required for close time rules."
    end
  end

  member_action :add_holiday_exclusions, method: :get do
    # debugger
    # authorize! :add_holiday_exclusions, resource
    resource.add_holidays(resource)
    redirect_to admin_schedule_path(params[:id]), notice: "Holidays have been added to the schedule."
  end

  member_action :refresh_holiday_exclusions, method: :get do
    resource.remove_holidays(resource)
    resource.add_holidays(resource)
    redirect_to admin_schedule_path(params[:id]), notice: "Holidays have been refreshed for the schedule."
  end

  member_action :remove_holiday_exclusions, method: :get do
    resource.remove_holidays(resource)
    redirect_to admin_schedule_path(params[:id]), notice: "Holidays have been removed from the schedule."
  end

  member_action :auto_save, method: :post do
    ActiveAdmin::DynamicFields.update(resource, params, %i[active exclude_lunch_time beginning_of_week])
    # redirect_to admin_schedule_path(params[:id]), notice: 'Beginning of week updated.'
  end

  member_action :disable_help, method: :get do
    current_admin_user.admin_user_help_preferences.where(controller_name: controller_name).first.update!(enabled: false)
    redirect_to send("edit_admin_#{controller_name.singularize}_path", params[:id]), notice: "You set the hide help admin user preference for #{controller_name.humanize}."
  end

  filter :id
  filter :name, input_html: { autocomplete: "off" }
  filter :active
  filter :capacity
  # filter :user_types, as: :select,
  #       collection: proc { current_admin_user.user_types.ordered }
  filter :exclude_lunch_time
  filter :time_zone, as: :select,
        collection: proc { Schedule.all.pluck(:time_zone).uniq }
  filter :beginning_of_week, as: :select,
        collection: Rule::DAYS_OF_WEEK.slice("Sunday", "Monday")

  # partials located in default location views/admin/schedules
  index do
    render partial: "index", locals: { context: self }
  end

  form partial: "form"

  # sidebar :help, only: :edit, if: proc { current_admin_user.admin_user_help_preferences.where(controller_name: controller_name).presence ? current_admin_user.admin_user_help_preferences.where(controller_name: controller_name).first.enabled : true } do
  #   div do
  #     h6 'Need help? Email us at help@example.com'
  #     render partial: 'sidebar', locals: { context: self }
  #     if current_admin_user.admin_user_help_preferences.where(controller_name: controller_name).presence
  #       div do
  #         link_to('Hide', send("disable_help_admin_#{controller_name.singularize}_path"), { class: 'button' })
  #       end
  #       div do
  #         sub '* Can be changed later.'
  #       end
  #     end
  #   end
  # end

  show do
    render partial: "show", locals: { context: self, events: events }
  end

  csv do
    column :id
    column :scheduleable_id
    column :scheduleable_type
    column :name
    column :active
    column :capacity
    # column(:user_types) { |schedule| UserType.where(id: schedule.user_types).ordered.pluck(:name).join(", ") }
    column :exclude_lunch_time
    column(:lunch_hour_start) { |schedule| schedule.lunch_hour_start&.to_time&.strftime("%I:%M %P") }
    column(:lunch_hour_end) { |schedule| schedule.lunch_hour_end&.to_time&.strftime("%I:%M %P") }
    column :time_zone
    column(:beginning_of_week) { |schedule| schedule.beginning_of_week.titleize }
    column(:rules) { |schedule| schedule.rules.map(&:name).join(", ") }
    column(:holidays, &:schedule_holiday_rule_exits?)
    column :created_at
    column :updated_at
  end
end
