require 'rails_helper'

RSpec.describe TransactionImport do
  let(:ofx) { File.read "spec/data/example.ofx" }

  describe '#save' do
    it 'should persist the bank transactions' do
      import = TransactionImport.new ofx: ofx
      expect { import.save }.to change { BankTransaction.count }.by(3)
      transaction = BankTransaction.find_by account_id: "00000000001", fit_id: "000000003"
      expect(transaction).to have_attributes({
        account_id: "00000000001",
        fit_id: "000000003",
        amount: 200,
        posted_at: "2007-03-14 11:00:00",
        data: {
          "account_id" => "00000000001",
          "amount" => "200.0",
          "fit_id" => "000000003",
          "memo" => "automatic deposit",
          "name" => "DEPOSIT",
          "payee" => "",
          "posted_at" => "2007-03-15T00:00:00.000+13:00",
          "ref_number" => "",
          "type" => "credit",
        }
      })
    end

    it 'should have errors for an invalid ofx' do
      import = TransactionImport.new ofx: ''
      expect(import.save).to be false
      expect(import.errors[:ofx]).to eq ["is invalid"]
    end

  end
end
