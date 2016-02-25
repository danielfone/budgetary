module Classifier
  class Dataset

    LAPLACE_SMOOTHING = 1

    def initialize
      @feature_counts = Hash.new { |h,k| h[k] = Hash.new LAPLACE_SMOOTHING }
      @category_counts = Hash.new 0
      @total_count = 0

      # Caching
      @_category_feature_count ||= Hash.new { |h,k| h[k] = Hash.new }
    end

    def categories
      @category_counts.keys
    end

    def train(category, features)
      @total_count += 1
      @category_counts[category] += 1

      features.each do |f|
        @feature_counts[f][category] += 1
      end
    end

    def classify(features)
      scores(features).keys.last
    end

    def scores(features)
      categories.each_with_object({}) do |cat, h|
        h[cat] = score cat, features
      end.sort_by {|k,v| v}.to_h
    end

    # P(category|features) = P(features|category) * P(category) / P(features)
    def score(category, features)
      Math.log(prior category) + features_likelihood(features, category)
    end

    def prior(category)
      @category_counts[category].to_f / @total_count
    end

    def features_likelihood(features, category)
      features.reduce(0) { |p,f| p += Math.log feature_likelihood f, category }
    end

    def feature_likelihood(feature, category)
      @feature_counts[feature][category].to_f / category_feature_count(category)
    end

    def category_feature_count(category)
      @_category_feature_count[@total_count][category] ||= @feature_counts.values.reduce(0) {|p, counts| p += counts[category] }
    end

  end
end
