class TransactionImport
  include ActiveModel::Model

  attr_accessor :ofx

  def save
    BankTransaction.import transactions
  rescue OFX::UnsupportedFileError
    errors.add :ofx, "is invalid"
    false
  end

private

  def transactions
    import.transactions.map { |t| bt = BankTransaction.new t; bt.data = t; bt }
  end

  def import
    Budgetary::Importer::OFXImport.new @ofx
  end

end
