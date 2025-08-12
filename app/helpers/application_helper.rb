module ApplicationHelper
  def current_user_meta_tags
    return nil unless respond_to?(:current_user)
    return nil unless current_user && user_signed_in?
    safe_join [
      tag(:meta, name: "current-user-id", content: current_user.id),
      tag(:meta, name: "current-user-name", content: current_user.name)
    ]
  end

  def current_admin_user_meta_tags
    return nil unless respond_to?(:current_admin_user)
    return nil unless current_admin_user && admin_user_signed_in?
    safe_join [
      tag(:meta, name: "current-user-id", content: current_admin_user.id),
      tag(:meta, name: "current-user-name", content: current_admin_user.name),
      tag(:meta, name: "current-user-data", content: current_admin_user.user_meta_data_tag)
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

  def dropzone_head_tags
    safe_join [
      tag(:script, src: "https://unpkg.com/dropzone@5/dist/min/dropzone.min.js"),
      tag(:link, rel: "stylesheet", href: "https://unpkg.com/dropzone@5/dist/min/dropzone.min.css", type: "text/css")
    ]
  end

  def dropzone_controller_div
    # content_for :dropzone_head_tags do
    #   dropzone_head_tags
    # end

    data = {
      controller: "dropzone",
      "dropzone-max-file-size"=>"8",
      "dropzone-max-files" => "10",
      "dropzone-accepted-files" => "image/jpeg,image/jpg,image/png,image/gif",
      "dropzone-dict-file-too-big" => "Váš obrázok ma veľkosť {{filesize}} ale povolené sú len obrázky do veľkosti {{maxFilesize}} MB",
      "dropzone-dict-invalid-file-type" => "Nesprávny formát súboru. Iba obrazky .jpg, .png alebo .gif su povolene"
    }

    content_tag :div, class: "dropzone dropzone-default dz-clickable", data: data do
      yield
    end
  end
end
