module ApplicationHelper
  def current_user_meta_tags
    return nil unless current_user && user_signed_in?
    safe_join [
      tag(:meta, name: "current-user-id", content: current_user.id),
      tag(:meta, name: "current-user-name", content: current_user.name)
    ]
  end
end
