class CreateEmails < ActiveRecord::Migration[8.0]
  def change
    create_table :emails do |t|
      t.references :emailable, polymorphic: true, null: false
      t.string :label, null: false
      t.string :email, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
