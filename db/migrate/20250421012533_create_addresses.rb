class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.references :addressable, polymorphic: true, null: false
      t.string :label
      t.string :address
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country, null: false, default: 'US'
      t.string :time_zone, null: false, default: 'Central Time (US & Canada)'
      t.string :url
      t.boolean :default, default: false, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
