class CreateStores < ActiveRecord::Migration[8.1]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :about

      t.timestamps
    end
  end
end
