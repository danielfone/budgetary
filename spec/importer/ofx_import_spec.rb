require 'importer/ofx_import'

module Budgetary::Importer
  RSpec.describe OFXImport do

    it 'should raise an error for invalid content' do
      expect { OFXImport.new '' }.to raise_error OFX::UnsupportedFileError
    end

    it 'should return an array of transactions' do
      ofx =  File.read "spec/data/example.ofx"
      import = OFXImport.new ofx
      transactions = import.transactions

      expect(transactions.size).to eq 3
      # NB, the ofx gem parses dates into system timezones :(
      expect(transactions.first).to eq({
        account_id: '00000000001',
        amount: 200,
        fit_id: "000000003",
        memo: "automatic deposit",
        name: "DEPOSIT",
        payee: "",
        posted_at: "2007-03-15 00:00:00 +1300",
        ref_number: "",
        type: :credit,
      })
    end
  end
end
