# frozen_string_literal: true

class PopoverComponentPreview < ApplicationPreview
  # @!group Playground
  #
  # Interactive Modal Preview
  # -----------------------
  # Configurable preview with live parameter editing in Lookbook UI
  #
  # Modal Configuration:
  # - id text "Unique identifier for the modal instance"
  # - title text "Header text shown at top of modal"
  # - text text "Optional descriptive text below title"
  # - position "Position of modal on screen"
  #  - Choices:
  #    - middle (default)
  #    - top
  #    - bottom
  #    - start
  #    - end
  # - *Modal Box Classes* modal_box_classes text "Optional - Additional CSS classes for modal container"
  # - actions [Boolean] "Optional - Show action buttons (default: false)"
  #
  # Trigger Configuration:
  # - trigger_tag select { choices: [[Button - Default, button], [Link, link], [Div, div]] } "HTML element type for modal trigger"
  # - trigger_text text "Text displayed on trigger element"
  # - trigger_class text "Custom CSS classes for trigger (overrides defaults)"
  #
  # Content Configuration:
  #
  # @param id text "Required - Unique identifier for the modal"
  # @param title text "Required - Modal title"
  # @param text text "Optional - Additional text content"
  # @param arrow [Boolean] "Optional - Show arrow"
  def playground(
    id: "playground",
    title: "Playground title",
    text: "And here's some amazing content. It's very engaging. Right?",
    arrow: true
  )
    render(PopoverComponent.new(id: id, title: title, text: text, arrow: arrow))
  end

  # @!endgroup

  def default(
    id: "popover",
    title: "Popover title",
    text: "And here's some amazing content. It's very engaging. Right?"
  )
    render(PopoverComponent.new(id: id, title: title, text: text))
  end

  def with_trigger(
    id: "trigger",
    title: "Trigger title",
    text: "And here's some amazing content. It's very engaging. Right?",
    arrow: true
  )
    render(PopoverComponent.new(id: id, title: title, text: text, arrow: arrow)) do |popover|
      popover.with_trigger do
        content_tag(:div, data: { popover_target: id, popover_trigger: "hover" }, class: "relative w-10 h-10 overflow-hidden bg-gray-100 rounded-full dark:bg-gray-600") do
          heroicon("user-circle", class: "w-10 h-10 object-cover")
        end
      end
    end
  end

  def with_trigger_on_form(
    id: "popover-password",
    arrow: true
  )
    render(PopoverComponent.new(id: id, arrow: arrow)) do |popover|
      popover.with_trigger do
        tag.input(
          data: {
            popover_target: id,
            popover_placement: "bottom"
          },
          type: "password",
          id: "password",
          placeholder: "Enter your password",
          class: "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500",
        )
      end

      tag.div(class: "p-3 space-y-2") do
        content_tag(:h3, "Must have at least 6 characters", class: "font-semibold text-gray-900 dark:text-white") +
        tag.div(class: "grid grid-cols-4 gap-2") do
          tag.div(class: "h-1 bg-orange-300 dark:bg-orange-400") +
          tag.div(class: "h-1 bg-orange-300 dark:bg-orange-400") +
          tag.div(class: "h-1 bg-gray-200 dark:bg-gray-600") +
          tag.div(class: "h-1 bg-gray-200 dark:bg-gray-600")
        end +
        tag.p("It's better to have:") +
        tag.ul do
          tag.li(class: "flex items-center mb-1") do
            heroicon("check", variant: :outline, class: "w-3.5 h-3.5 me-2 text-green-400 dark:text-green-500") +
            "Upper & lower case letters"
          end +
          tag.li(class: "flex items-center mb-1") do
            heroicon("x-mark", variant: :outline, class: "w-3 h-3 me-2.5 text-gray-300 dark:text-gray-400") +
            "A symbol (#$&)"
          end +
          tag.li(class: "flex items-center") do
            heroicon("x-mark", variant: :outline, class: "w-3 h-3 me-2.5 text-gray-300 dark:text-gray-400") +
            "A longer password (min. 12 chars.)"
          end
        end
      end
    end
  end
end
