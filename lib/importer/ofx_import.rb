require 'ofx'

module Budgetary::Importer
  class OFXImport

    def initialize(ofx)
      @parser = OFX(ofx)
    end

    def account
      @parser.account
    end

    def transactions
      account.transactions.map do |t|
        {
          account_id: account.id,
          amount: t.amount,
          fit_id: t.fit_id,
          memo: t.memo,
          name: t.name,
          payee: t.payee,
          posted_at: t.posted_at,
          ref_number: t.ref_number,
          type: t.type,
        }
      end
    end
  end
end
