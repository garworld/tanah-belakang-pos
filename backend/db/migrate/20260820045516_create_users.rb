class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")

    create_table :users, id: :uuid do |t|
      t.string :name, null: false, limit: 100
      t.text :pin_hash, null: false
      t.string :role, null: false, limit: 20
      t.boolean :is_active, null: false, default: true
      t.timestamps null: false
    end

    add_check_constraint :users,
    "role IN ('CASHIER', 'ADMIN')",
    name: "users_role_check"
  end
end
