class CreateContacts < ActiveRecord::Migration[8.1]
  def change
    create_table :contacts do |t|
      t.string :email, null: false
      t.boolean :subscribed, default: false

      t.timestamps
    end

    add_index :contacts, :email, unique: true
  end
end
