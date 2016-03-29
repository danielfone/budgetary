class BankTransaction < ApplicationRecord
  belongs_to :category, class_name: "TxnCategory", foreign_key: :txn_category_id

  store_accessor :data, *[
    :memo,
    :name,
    :payee,
    :ref_number,
    :type,
  ]

  def self.performance_by_category(period: :month, start_date: 12.months.ago.beginning_of_month, end_date: Date.current)
    where('posted_at BETWEEN ? AND ?', start_date.to_date, end_date.to_date)
    .group("date_trunc('#{period}', posted_at)")
    .group(:txn_category_id)
    .order('2')
    .sum(:amount)
  end

end
