module Budgetary::Classifier
  class TxnDataset
    attr_accessor :data

    # FEATURES:
    # - amount: NOT gaussian, will need to bucket and do multinomial?
    # - account_id
    # - memo / name / payee?
    # - day of month?
    # - day of week?

    AMOUNT_BIN_SIZE = 50

    def initialize
      @category_counts = Hash.new 0
      @category_priors = Hash.new 0
      @amount_features = Hash.new { |h,k| h[k] = Hash.new 0 }
      @memo_features = Hash.new { |h,k| h[k] = Hash.new 0 }
      @total_count = 0
    end

    def train(category, txn)
      @total_count += 1

      @category_counts[category] += 1

      amount = amount_bin txn['amount']
      @amount_features[category][amount] += 1

      memo_bins(txn['memo']).each do |m|
        @memo_features[category][m] += 1
      end
    end

    def classify(txn)
      category, count = category_distribution(txn).last # sort by probability, get the highest (last)
      # need to check distribution, don't pick a category if it's uncertain
      category
    end

    def category_distribution(txn)
      probabilities = categories.each_with_object({}) { |c,h| h[c] = score txn, c }
      probabilities.sort_by(&:last) # sort by probability
    end

    def categories
      @categories ||= @category_counts.keys
    end

#  private

    # P(txn|category)
    def score(txn, category)
      category_prior = @category_counts[category] / @total_count.to_f
      memo_likelihood(txn, category) * amount_likelihood(txn, category) * category_prior
    end

    def amount_likelihood(txn, category)
      amount = amount_bin txn['amount']
      @amount_features[category][amount] / @category_counts[category].to_f
    end

    def memo_likelihood(txn, category)
      memo_bins(txn['memo']).reduce(1) do |p,m|
        p * (@memo_features[category][m] / @category_counts[category].to_f)
      end
    end

    def amount_bin(amount)
      amount.to_i / AMOUNT_BIN_SIZE
    end

    def memo_bins(memo)
      memo.downcase.split
    end

  end
end
