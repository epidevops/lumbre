class CreatePhones < ActiveRecord::Migration[8.0]
  def change
    create_table :phones do |t|
      t.references :phoneable, polymorphic: true, null: false
      t.string :label
      t.string :phone
      t.boolean :default, default: false, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
