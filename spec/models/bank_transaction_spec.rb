require 'rails_helper'

RSpec.describe BankTransaction do

  describe '::performance_by_category' do
    before do
      create :txn_category, id: 1
      create :txn_category, id: 2
      create :txn_category, id: 3
      create :bank_transaction, posted_at: '2012-02-01', txn_category_id: 1, amount: 5
      create :bank_transaction, posted_at: '2012-02-01', txn_category_id: 1, amount: 10
      create :bank_transaction, posted_at: '2012-01-01', txn_category_id: 2, amount: 20
    end

    it 'should sum categories amounts by month' do
      expect(BankTransaction.performance_by_category start_date: '2012-01-01').to eq({
        [Time.zone.parse('2012-01-01'), 2] => 20,
        [Time.zone.parse('2012-02-01'), 1] => 15,
      })
    end
  end

end
