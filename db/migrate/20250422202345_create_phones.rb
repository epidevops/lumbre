class CreatePhones < ActiveRecord::Migration[8.0]
  def change
    create_table :phones do |t|
      t.references :phoneable, polymorphic: true, null: false
      t.string :label, null: false
      t.string :phone, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
