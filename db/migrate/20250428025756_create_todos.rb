class CreateTodos < ActiveRecord::Migration[8.1]
  def change
    create_table :todos do |t|
      t.string :category
      t.string :name
      t.boolean :active, default: true
      t.integer :position, null: false

      t.timestamps
    end
  end
end
