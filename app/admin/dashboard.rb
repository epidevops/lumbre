# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    div class: "px-4 py-16 md:py-32 text-center m-auto max-w-3xl" do
      h2 "Welcome to ActiveAdmin", class: "text-base font-semibold leading-7 text-indigo-600 dark:text-indigo-500"
      para "This is the default page", class: "mt-2 text-3xl sm:text-4xl font-bold text-gray-900 dark:text-gray-200"
      para class: "mt-6 text-xl leading-8 text-gray-700 dark:text-gray-400" do
        text_node "To update the content, edit the"
        strong "app/admin/dashboard.rb"
        text_node "file to get started."
      end
    end

    panel "Admin Tools" do
      if Flipper.enabled?(:super_admin_access, current_admin_user)
        h3 { b { link_to("Blazer", mount_blazer_path, target: "_blank") } }
        h3 { b { link_to("Litequeen", mount_solid_litequeen_path, target: "_blank") } }
        h3 { b { link_to("Mission Control Jobs", mount_mission_control_jobs_path, target: "_blank") } }
        h3 { b { link_to("Letter Opener", mount_letter_opener_web_path, target: "_blank") } }
        h3 { b { link_to("Lookbook", mount_lookbook_path, target: "_blank") } }
        h3 { b { link_to("Exception Track", mount_exception_track_path, target: "_blank") } }
      end
      h3 { b { link_to("Flipper", "/flipper", target: "_blank") } }
      # h3 { b { link_to('Model Graph', '/models') } }
      # h3 { b { link_to('PgHero', '/pghero') } }
      # h3 { b { link_to('Sidekiq', '/sidekiq') } }
      # h3 { b { link_to('Vue Playground', '/vue-playground') } }
    end
  end
end
