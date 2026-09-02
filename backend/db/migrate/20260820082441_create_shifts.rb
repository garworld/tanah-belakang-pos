class CreateShifts < ActiveRecord::Migration[8.1]
  def up
    create_table :shifts, id: :uuid do |t|
      t.references :user,
                   null: false,
                   foreign_key: true,
                   type: :uuid

      t.integer :opening_cash, null: false
      t.integer :actual_closing_cash

      t.datetime :opened_at, null: false
      t.datetime :closed_at

      t.string :status, null: false, limit: 20

      t.timestamps null: false
    end

    add_check_constraint :shifts,
                         "opening_cash >= 0",
                         name: "shifts_opening_cash_check"

    add_check_constraint :shifts,
                         "actual_closing_cash IS NULL OR actual_closing_cash >= 0",
                         name: "shifts_closing_cash_check"

    add_check_constraint :shifts,
                         "status IN ('OPEN', 'CLOSED')",
                         name: "shifts_status_check"

    add_check_constraint :shifts,
                         <<~SQL.squish,
                           (
                             status = 'OPEN'
                             AND closed_at IS NULL
                             AND actual_closing_cash IS NULL
                           )
                           OR
                           (
                             status = 'CLOSED'
                             AND closed_at IS NOT NULL
                             AND actual_closing_cash IS NOT NULL
                           )
                         SQL
                         name: "shifts_state_check"

    add_index :shifts,
              :user_id,
              unique: true,
              where: "status = 'OPEN'",
              name: "index_shifts_one_open_per_user"
  end

  def down
    drop_table :shifts, if_exists: true
  end
end