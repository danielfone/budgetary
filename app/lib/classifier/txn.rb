module Classifier
  class Txn < Struct.new(:attrs)
    AMOUNT_BIN_SIZE = 10

    def self.features(*args)
      new(*args).features
    end

    def features
      memo_features.map { |m| "memo:#{m}" } + [
        "amount:#{amount}",
      ]
    end

  private

    def memo_features
      attrs['memo'].downcase.split.map { |m| m.delete '^a-z' }
    end

    def amount
      attrs['amount'].to_i / AMOUNT_BIN_SIZE
    end

  end
end
