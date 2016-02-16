class CreateBankTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :bank_transactions do |t|
      t.string :account_id, null: false
      t.string :fit_id, null: false
      t.decimal :amount, null: false
      t.datetime :posted_at, null: false
      t.json :data

      t.timestamps

      t.index [:account_id, :fit_id], unique: true
    end
  end
end
