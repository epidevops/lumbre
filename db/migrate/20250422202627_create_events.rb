class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.references :eventable, polymorphic: true, null: false
      t.string :label
      t.string :start_day
      t.string :end_day
      t.string :start_time
      t.string :end_time
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
