class FlowbiteToggleInput < Formtastic::Inputs::BooleanInput
  def to_html
    input_wrapping do
      template.content_tag(:label, class: "inline-flex items-center cursor-pointer") do
        builder.check_box(method, input_html_options.merge(
          class: "sr-only peer",
          value: "1"
        )) <<
        template.content_tag(:div, "", class: "relative w-14 h-7 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-0.5 after:start-[4px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-6 after:w-6 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600 dark:peer-checked:bg-blue-600") <<
        template.content_tag(:span, label_text, class: "ms-3 text-sm font-medium text-gray-900 dark:text-gray-300")
      end
    end
  end

  def label_wrapping(&block)
    template.content_tag(:label,
      template.capture(&block),
      class: "inline-flex items-center cursor-pointer",
      for: input_dom_id
    )
  end

  # def hidden_checkbox_html
  #   builder.check_box(method, input_html_options.merge(
  #     class: "sr-only peer",
  #     value: "1",
  #     checked: object.send(method) ? "checked" : nil
  #   ))
  # end


  def input_wrapping(&block)
    template.content_tag(:li,
      template.capture(&block),
      wrapper_html_options
    )
  end

  def wrapper_html_options
    super.tap do |options|
      options[:class] = "input flowbite-toggle"
      options[:id] = "#{object_name}_#{method}_input"
    end
  end

  def input_dom_id
    "#{object_name}_#{method}".gsub(/\W/, "_")
  end
end

# <li class="input" id="admin_user_active_input">
#   <label for="admin_user_active" class="inline-flex items-center cursor-pointer">
#     <input id="admin_user_active" name="admin_user[active]" type="checkbox" value="" class="sr-only peer">
#     <div class="relative w-14 h-7 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-0.5 after:start-[4px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-6 after:w-6 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600 dark:peer-checked:bg-blue-600"></div>
#     <span class="ms-3 text-sm font-medium text-gray-900 dark:text-gray-300">toggle_label</span>
#   </label>
# </li>


# <label class="inline-flex items-center cursor-pointer">
#   <input type="checkbox" value="" class="sr-only peer">
#   <div class="relative w-14 h-7 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-0.5 after:start-[4px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-6 after:w-6 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600 dark:peer-checked:bg-blue-600"></div>
#   <span class="ms-3 text-sm font-medium text-gray-900 dark:text-gray-300">Enable Email</span>
# </label>

# <li class="boolean input optional" id="admin_user_active_input">
#   <input type="hidden" name="admin_user[active]" value="0" autocomplete="off">
#   <label for="admin_user_active" class="">
#   <input type="checkbox" name="admin_user[active]" id="admin_user_active" value="1" checked="checked">Active</label>
# </li>

# <li class="boolean input optional" id="admin_user_active_input">
#   <input type="hidden" name="admin_user[active]" value="0" autocomplete="off">
#   <label for="admin_user_active" class="">
#   <input type="checkbox" name="admin_user[active]" id="admin_user_active" value="1">Active</label>
# </li>
