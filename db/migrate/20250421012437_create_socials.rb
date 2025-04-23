class CreateSocials < ActiveRecord::Migration[8.1]
  def change
    create_table :socials do |t|
      t.references :socialable, polymorphic: true, null: false
      t.string :name
      t.string :url
      t.string :icon
      t.boolean :active, default: true, null: false
      t.timestamps
    end
  end
end
