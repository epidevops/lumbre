require "zlib"

module AdminUsers::AvatarsHelper
  AVATAR_COLORS = %w[
    #AF2E1B #CC6324 #3B4B59 #BFA07A #ED8008 #ED3F1C #BF1B1B #736B1E #D07B53
    #736356 #AD1D1D #BF7C2A #C09C6F #698F9C #7C956B #5D618F #3B3633 #67695E
  ]

  def avatar_background_color(admin_user)
    AVATAR_COLORS[Zlib.crc32(user.to_param) % AVATAR_COLORS.size]
  end

  # def avatar_tag(admin_user, **options)
  #   link_to admin_user_path(admin_user), title: admin_user.title, class: "btn avatar", data: { turbo_frame: "_top" } do
  #     image_tag fresh_admin_user_avatar_path(admin_user), aria: { hidden: "true" }, size: 48, **options
  #   end
  # end
end
