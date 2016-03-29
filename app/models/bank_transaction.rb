class BankTransaction < ApplicationRecord
  belongs_to :category, class_name: "TxnCategory", foreign_key: :txn_category_id

  store_accessor :data, *[
    :memo,
    :name,
    :payee,
    :ref_number,
    :type,
  ]
end
