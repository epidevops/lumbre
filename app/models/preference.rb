class Preference < ApplicationRecord
  belongs_to :preferenceable, polymorphic: true
end
