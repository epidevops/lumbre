class CreateSystemContactTypeLabels < ActiveRecord::Migration[8.0]
  def change
    create_table :system_contact_type_labels do |t|
      t.string :contact_type, null: false
      t.string :label, null: false

      t.timestamps
    end
    add_index :system_contact_type_labels, [ :contact_type, :label ], unique: true
  end
end
