class CreateStores < ActiveRecord::Migration[8.1]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :slogan
      t.boolean :active, default: true
      t.boolean :primary, default: true

      t.timestamps
    end
  end
end
