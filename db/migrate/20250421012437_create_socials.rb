class CreateSocials < ActiveRecord::Migration[8.1]
  def change
    create_table :socials do |t|
      t.references :socialable, polymorphic: true, null: false
      t.string :name, null: false
      t.string :url, null: false
      t.string :icon, null: false
      t.boolean :active, default: true, null: false
      t.timestamps
    end
  end
end
