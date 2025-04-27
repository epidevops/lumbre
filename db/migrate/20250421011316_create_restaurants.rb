class CreateRestaurants < ActiveRecord::Migration[8.1]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :slogan
      t.text :hero_text
      t.text :about_text
      t.boolean :enable_weekly_deals, default: true, null: false
      t.boolean :enable_meet_the_team, default: true, null: false
      t.boolean :enable_subscribe, default: true, null: false
      t.boolean :enable_gallery, default: true, null: false
      t.boolean :enable_testimonials, default: true, null: false
      t.boolean :active, default: true, null: false
      t.boolean :primary, default: true, null: false

      t.timestamps
    end
  end
end
