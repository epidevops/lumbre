module NoticedAssociations
  extend ActiveSupport::Concern

  included do
    has_many :notifications, as: :recipient, dependent: :destroy, class_name: "Noticed::Notification"
    has_many :notification_mentions, as: :record, dependent: :destroy, class_name: "Noticed::Event"
  end
end
