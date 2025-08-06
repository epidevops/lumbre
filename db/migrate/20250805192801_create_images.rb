class CreateImages < ActiveRecord::Migration[8.0]
  def change
    create_table :images do |t|
      t.references :imageable, polymorphic: true, null: false
      t.integer :position, null: false

      t.timestamps
    end
    add_index :images, [ :imageable_id, :imageable_type, :position ], unique: true
  end
end
