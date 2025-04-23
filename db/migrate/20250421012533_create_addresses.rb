class CreateAddresses < ActiveRecord::Migration[8.1]
  def change
    create_table :addresses do |t|
      t.references :addressable, polymorphic: true, null: false
      t.string :label
      t.string :address
      t.string :url
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
