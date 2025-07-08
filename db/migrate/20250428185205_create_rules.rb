class CreateRules < ActiveRecord::Migration[8.0]
  def change
    create_table :rules do |t|
      t.belongs_to :schedule, null: false, foreign_key: true
      t.string :rule_type
      t.string :name
      t.string :frequency_units
      t.integer :frequency
      t.json :days_of_week, default: [], null: false
      t.date :start_date
      t.date :end_date
      t.string :rule_hour_start
      t.string :rule_hour_end

      t.timestamps
    end
  end
end
