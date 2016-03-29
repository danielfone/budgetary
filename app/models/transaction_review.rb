class TransactionReview < BankTransaction

  default_scope -> { where txn_category_id: nil }

  after_save :train_classifier

  def suggested_category_id
    dataset.classify features
  end

private

  def dataset
    @dataset = Classifier::Dataset.new
  end

  def features
    @features ||= Classifier::Txn.features data
  end

  def train_classifier
    dataset.train txn_category_id, features
  end

end
