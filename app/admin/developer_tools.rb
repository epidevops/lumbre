# frozen_string_literal: true

ActiveAdmin.register_page "Developer Tools" do
  menu parent: "administration", priority: 3, if: proc { current_admin_user.super_admin? || Flipper.enabled?(:super_admin_access, current_admin_user) }

  content do
    tabs do
      tab "Tools" do
        div render "admin/developer_tools/index"
      end
      tab "Active Admin" do
        tabs do
          tab "Gem Colors" do
            div render "admin/developer_tools/active_admin_colors"
          end
          tab "Assets Plugin" do
            div render "admin/developer_tools/active_admin_plugin_js"
          end
          tab "All Tailwind 3.4 Colors" do
            div render "admin/developer_tools/active_admin_tailwind_34_colors"
          end
          tab "Tailwind 3.4 CSS" do
            div render "admin/developer_tools/tailwind_34_css"
          end
        end
      end
    end
  end
end
