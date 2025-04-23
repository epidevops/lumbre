class CreateRestaurants < ActiveRecord::Migration[8.1]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :slogan
      t.text :hero_text
      t.text :about_text

      t.timestamps
    end
  end
end
