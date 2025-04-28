class Todo < ApplicationRecord
  validates :category, :name, :active, presence: true
  acts_as_list scope: [ :category ]
end
