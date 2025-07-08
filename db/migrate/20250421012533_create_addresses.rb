class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.references :addressable, polymorphic: true, null: false
      t.string :label, null: false
      t.string :address, null: false
      t.string :url
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
