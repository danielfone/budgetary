class CreateTxnCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :txn_categories do |t|
      t.string :name, null: false
      t.string :category_type, null: false
      t.decimal :budget
      t.string :budget_period
      t.boolean :archived, null: false, default: false

      t.index :archived
      t.index :category_type

      t.timestamps
    end

    add_reference :bank_transactions, :txn_category, foreign_key: true
  end
end
