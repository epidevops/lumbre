class CreateAccessControl < ActiveRecord::Migration[8.1]
  def change
    create_table :access_types do |t|
      t.string :key, null: false
      t.string :name

      t.timestamps
    end
    add_index :access_types, :key, unique: true

    create_table :access_resources do |t|
      t.string :key, null: false
      t.string :resource_class, null: false
      t.string :label, null: false
      t.string :source, null: false, default: "active_admin"
      t.string :menu_parent
      t.string :kind, null: false, default: "model"

      t.timestamps
    end
    add_index :access_resources, :key, unique: true
    add_index :access_resources, :resource_class, unique: true
    add_index :access_resources, :kind

    create_table :index_scope_rules do |t|
      t.string :key, null: false
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
    add_index :index_scope_rules, :key, unique: true

    create_table :access_authorizations do |t|
      t.references :access_type, null: false, foreign_key: true
      t.references :access_resource, foreign_key: true
      t.string :key, null: false
      t.string :label, null: false
      t.string :action

      t.timestamps
    end
    add_index :access_authorizations, [ :access_type_id, :key ], unique: true

    create_table :permissions do |t|
      t.references :role, null: false, foreign_key: true, index: false

      t.timestamps
    end
    add_index :permissions, :role_id, unique: true

    create_table :permission_grants do |t|
      t.references :permission, null: false, foreign_key: true
      t.references :access_authorization, null: false, foreign_key: true
      t.boolean :granted, null: false, default: false

      t.timestamps
    end
    add_index :permission_grants,
              [ :permission_id, :access_authorization_id ],
              unique: true,
              name: "index_permission_grants_on_permission_and_authorization"

    create_table :permission_resource_scopes do |t|
      t.references :permission, null: false, foreign_key: true
      t.references :access_resource, null: false, foreign_key: true
      t.references :index_scope_rule, null: false, foreign_key: true

      t.timestamps
    end
    add_index :permission_resource_scopes,
              [ :permission_id, :access_resource_id ],
              unique: true,
              name: "index_permission_resource_scopes_on_permission_and_resource"
  end
end
