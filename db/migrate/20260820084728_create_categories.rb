class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories, id: :uuid do |t|
      t.string :name, null: false, limit: 100

      t.integer :sort_order, null: false, default: 0

      t.boolean :is_active, null: false, default: true

      t.timestamps null: false
    end

    add_check_constraint :categories,
                         "sort_order >= 0",
                         name: "categories_sort_order_check"
  end
end