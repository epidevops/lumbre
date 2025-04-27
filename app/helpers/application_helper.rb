module ApplicationHelper
  def current_user_meta_tags
    return nil unless current_user && user_signed_in?
    safe_join [
      tag(:meta, name: "current-user-id", content: current_user.id),
      tag(:meta, name: "current-user-name", content: current_user.name)
    ]
  end

  def render_turbo_stream_flash_messages
    turbo_stream.prepend "flash", partial: "layouts/flash"
  end

  def safe_url(url)
    uri = URI.parse(url)

    uri.to_s if uri.is_a?(URI::HTTP)
  rescue URI::InvalidURIError
    nil
  end
end
