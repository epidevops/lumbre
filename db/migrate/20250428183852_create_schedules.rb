class CreateSchedules < ActiveRecord::Migration[8.0]
  def change
    create_table :schedules do |t|
      t.references :scheduleable, polymorphic: true, null: false
      t.string :name, null: false
      t.boolean :active, null: false, default: false
      t.integer :capacity, default: 5
      t.boolean :exclude_lunch_time, default: false
      t.string :lunch_hour_start
      t.string :lunch_hour_end
      t.string :beginning_of_week, default: "sunday"
      t.string :time_zone, null: false, default: "Mountain Time (US & Canada)"

      t.timestamps
    end
  end
end
