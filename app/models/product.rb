class Product < ApplicationRecord
  belongs_to :productable, polymorphic: true
  has_one_attached :product_image do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 100, 100 ], preprocessed: true
  end

  # has_many :images, as: :imageable, dependent: :destroy
  has_many_attached :photos do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 100, 100 ], preprocessed: true
  end

  positioned on: [ :productable, :category ]

  scope :active, -> { where(active: true) }
  scope :category, ->(category) { where(category: category) }
  extend Mobility
  translates :title, type: :string
  translates :description, type: :text
  translates :recommended_text, type: :string
end
