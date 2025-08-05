# frozen_string_literal: true

class PopoverComponent < ApplicationComponent
  renders_one :trigger

  def initialize(id:, title: nil, text: nil, arrow: true, data: {})
    @id = id
    @title = title
    @text = text
    @arrow = arrow
    @data = data
  end

  def default_trigger
    content_tag(:button, "Default popover", type: "button", data: { popover_target: @id, popover_trigger: "hover", popover_placement: "bottom" }, class: "text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800")
  end

  def render?
    trigger?
  end
end
