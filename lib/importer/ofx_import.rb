require 'ofx'

module Budgetary::Importer
  class OFXImport

    def initialize(ofx)
      @parser = OFX(ofx)
    end

    def transactions
      @parser.account.transactions.map do |t|
        {
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
