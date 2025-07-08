class CreateScheduleEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :schedule_events do |t|
      t.belongs_to :schedule, null: false, foreign_key: true
      t.datetime :event_time

      t.timestamps
    end
  end
end
