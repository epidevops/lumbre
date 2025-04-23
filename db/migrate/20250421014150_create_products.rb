class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.references :productable, polymorphic: true, null: false
      t.string :category
      t.string :title
      t.text :description
      t.string :price
      t.boolean :recommended, default: false, null: false
      t.string :recommended_text, default: "Chef's Selection", null: false
      t.string :discount_percent
      t.string :options
      t.boolean :active, default: true, null: false
      t.integer :sequential_id, null: false

      t.timestamps
    end
    add_index :products, [ :sequential_id, :productable_id, :productable_type ], unique: true
  end
end
