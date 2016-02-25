module Classifier
  class Dataset

    def initialize
      @category_counts = Hash.new 0
      @feature_counts = Hash.new { |h,k| h[k] = Hash.new 0 }
      @total_count = 0
    end

    def categories
      @categories ||= @category_counts.keys
    end

    def train(category, features)
      @total_count += 1
      @category_counts[category] += 1

      features.each do |f|
        # ??? @category_counts[category] += 1
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
      features.reduce Math.log prior category do |p,f|
        p += Math.log feature_likelihood f, category
      end
    end

    def prior(category)
      @category_counts[category].to_f / @total_count
    end

    def feature_likelihood(feature, category)
      @feature_counts[feature][category].to_f / @category_counts[category]
    end

  end
end
