class BankTransaction < ApplicationRecord
  store_accessor :data, *[
    :memo,
    :name,
    :payee,
    :ref_number,
    :type,
  ]
end
