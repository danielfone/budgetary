class TxnCategory < ApplicationRecord
  before_validation :set_default_type

private

  def set_default_type
    self.category_type ||= :expense
  end
end
