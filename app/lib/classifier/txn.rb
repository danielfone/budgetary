module Classifier
  class Txn < Struct.new(:attrs)

    def self.features(*args)
      new(*args).features
    end

    def features
      attrs['memo'].downcase.split.map { |m| m.delete '^a-z' }.reject { |m| m.size < 2 }
    end

  end
end
