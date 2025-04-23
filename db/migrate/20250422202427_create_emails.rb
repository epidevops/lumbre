class CreateEmails < ActiveRecord::Migration[8.1]
  def change
    create_table :emails do |t|
      t.references :emailable, polymorphic: true, null: false
      t.string :label
      t.string :email
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
