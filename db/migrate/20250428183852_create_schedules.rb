class CreateSchedules < ActiveRecord::Migration[8.0]
  def change
    create_table :schedules do |t|
      t.references :scheduleable, polymorphic: true, null: false
      t.string :name, null: false
      t.boolean :active, null: false, default: false
      t.integer :capacity, default: 1
      t.boolean :exclude_lunch_time, default: true
      t.string :lunch_hour_start
      t.string :lunch_hour_end
      t.string :beginning_of_week, default: "monday"
      t.string :time_zone

      t.timestamps
    end
  end
end
