class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.references :productable, polymorphic: true, null: false
      t.string :category
      t.string :title
      t.text :description
      t.string :price
      t.boolean :recommended, default: false, null: false
      t.string :recommended_text
      t.string :discount_percent
      t.string :options
      t.boolean :active, default: true, null: false
      t.integer :position, null: false

      t.timestamps
    end
    add_index :products, [ :productable_id, :productable_type, :category, :position ], unique: true
  end
end
