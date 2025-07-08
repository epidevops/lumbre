class CreateContactMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :contact_messages do |t|
      t.references :contact, null: false, foreign_key: true
      t.string :message, null: false

      t.timestamps
    end
  end
end
