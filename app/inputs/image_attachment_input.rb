# frozen_string_literal: true

class ImageAttachmentInput < Formtastic::Inputs::FileInput
  DEFAULT_IMAGE_SIZE = 100

  def to_html
    input_wrapping do
      [
        label_html,
        file_input_html,
        image_preview_html
      ].join.html_safe
    end
  end

  protected

  def file_input_html
    builder.file_field(method, input_html_options.merge(
      class: dynamic_id_or_class("file-input", :class),
      accept: "image/*",
      direct_upload: true,
      style: "display: none;",
      data: {
        update_target: options[:update_target],
        event_name: options[:event_name] || "image:updated"
      }
    ))
  end

  def image_preview_html
    [ camera_container_html, image_container_html, delete_container_html ].join.html_safe
  end

  def camera_container_html
    builder.template.content_tag(:div, id: dynamic_id_or_class("container_camera", :id), class: dynamic_id_or_class("container-camera", :class)) do
      camera_image_html
    end
  end

  def image_container_html
    builder.template.content_tag(:div, id: dynamic_id_or_class("container_image", :id), class: dynamic_id_or_class("container-image", :class)) do
      attachment_present? ? attached_image_html : default_image_html
    end
  end

  def delete_container_html
    return nil unless attachment_present?
    builder.template.content_tag(:div, id: dynamic_id_or_class("container_delete", :id), class: dynamic_id_or_class("container-delete", :class)) do
      delete_image_html
    end
  end

  def attached_image_html
    return nil unless attachment_present?
    builder.template.image_tag(attachment_url, class: dynamic_id_or_class("image-attached", :class)).html_safe
  end

  def camera_image_html
    builder.template.image_tag("camera.svg", aria: { hidden: "true" }, size: 20, class: dynamic_id_or_class("image-camera", :class)).html_safe
  end

  def delete_image_html
    builder.template.image_tag("minus.svg", aria: { hidden: "true" }, size: 20, class: dynamic_id_or_class("image-delete", :class)).html_safe
  end

  def default_image_html
    builder.template.image_tag(default_image, aria: { hidden: "true" }, class: dynamic_id_or_class("image-default", :class)).html_safe
  end

  def file_hidden_input_html
    return nil unless attachment_present?
    builder.hidden_field(method, input_html_options.merge(
      value: image_token
    ))
  end

  def image_token
    object.method.blob.signed_id(purpose: attachment_method_symbol)
  end

  def default_image_size
    # debugger
    options[:default_image_size].presence || DEFAULT_IMAGE_SIZE
  end

  def attachment_url
    object.send(thumb_method)
  end

  def thumb_method
    "#{method}_thumb"
  end

  def attachment_present?
    object.send(method).attached?
  end

  def default_image
    # default_image_from_options || fallback_default_image
    options[:default_image].presence || "default-avatar.svg"
  end

  def default_image_from_options
    options[:default_image].presence
  end

  def fallback_default_image
    case object_name.to_sym
    # when :company
    #   'default-company-logo.svg'
    # when :account
    #   'logos/arctic-icon-192.png'
    when :admin_user
      "default-avatar.svg"
    else
      "default-avatar.svg"
      # 'default-upload-fallback.svg'
    end
  end

  def attachment_method_symbol
    self.method
  end

  def dynamic_id_or_class(name, type)
    name, type = normalize([ name, type ])
    id = normalize([ "image_attachment", name, object_name, attachment_method_symbol ]).join("_")
    type == "id" ? id : id.gsub("_", "-")
  end

    def normalize(array)
      array.map(&:to_s).map(&:downcase)
    end
end
