# frozen_string_literal: true

ActiveAdmin.register_page "DeveloperTools" do
  content do
    tabs do
      tab "Demo" do
        div render "admin/developer_tools/index"
      end
      tab "Colors" do
        div render "admin/developer_tools/card"
      end
      tab "Tailwind 3.4 Colors" do
        div render "admin/developer_tools/tailwind_34_colors"
      end
      tab "activeadmin_assets plugin" do
        div render "admin/developer_tools/plugin_js"
      end
    end
  end
end
