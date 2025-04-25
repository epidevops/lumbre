module EmailValidations
  extend ActiveSupport::Concern

  included do
    validates :email, presence: true, uniqueness: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

    normalizes :email, with: ->(email) { email.downcase }
  end
end
