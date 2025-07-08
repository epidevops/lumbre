class CreateRestaurants < ActiveRecord::Migration[8.0]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :slogan
      t.text :hero_text
      t.text :about_text
      t.boolean :active, default: true, null: false
      t.boolean :primary, default: true, null: false

      t.timestamps
    end
  end
end
