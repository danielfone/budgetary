module Budgetary::Classifier
  class TxnDataset
    attr_accessor :data

    # FEATURES:
    # - amount: NOT gaussian, will need to bucket and do multinomial?
    # - account_id
    # - memo / name / payee?
    # - day of month?
    # - day of week?

    def initialize
      @category_counts = Hash.new 1
      @amount_counts = Hash.new 1 # experiment with bin size
      @amount_features = Hash.new Hash.new 1
      @memo_count = Hash.new Hash.new 1
      @memo_features = Hash.new Hash.new 1
      @total_count = 1
    end

    def train(category, txn)
      @category_counts[category] += 1
      @total_count += 1
    end

    def classify(txn)
      probabilities = categories.each_with_object({}) { |c,h| h[c] = score txn, c }
      category, count = probabilities.sort_by(&:last).last # sort by probability, get the highest (last)
      # need to check distribution, don't pick a category if it's uncertain
      category
    end

    def categories
      @categories ||= @category_counts.keys
    end

  private

    # P(txn|category)
    def score(txn, category)
      category_prior = @category_counts[category] / @total_count
    #  observation.reduce(1) { |p,f,v| p * probability(f, v, category) } * category_probability
    end

    ## P(feature|category)
    #def probability(feature, value, category)
    #  tokens = value.split(/\s/)
    #  tokens.reduce(1).each do |p,token|
    #    # P(memo contains "FISH"|category="Holiday")
    #    p * (features[category][token] / features[category])
    #  end
#
    #end
  end
end
