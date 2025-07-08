class CreatePreferences < ActiveRecord::Migration[8.0]
  def change
    create_table :preferences do |t|
      t.references :preferenceable, polymorphic: true, null: false
      t.string :preferred_language, null: false, default: "en"
      t.string :time_zone, null: false, default: "UTC"
      t.string :theme, null: false, default: "system"
      t.boolean :enable_email, null: false, default: false
      t.boolean :enable_sms, null: false, default: false
      t.boolean :enable_web_push, null: false, default: false
      t.boolean :enable_mobile_push, null: false, default: false

      t.timestamps
    end
  end
end
