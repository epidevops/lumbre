class FlowbiteAvatarInput
  include Formtastic::Inputs::Base

  def to_html
    fallback_image
  end

  def fallback_image
    inline_svg_tag "default-admin-avatar.svg", class: "rounded-full w-10 h-10"
  end
end
