module Classifier
  class Benchmark

    ITERATIONS = 100

    def initialize
      @data = JSON.load(File.read "spec/data/txn-training.json")
      @d1_klass, @t1_klass = Dataset, Txn
      @d2_klass, @t2_klass = NewDataset, Txn2
    end

    def score
      ITERATIONS.times do
        start = rand 500
        partition = start + rand(1500)
        stop = -rand(100)
        @training_txns = @data[start..partition] # ~ 70% training
        @testing_txns = @data[partition..stop] # ~ 30% test

        d1 = @d1_klass.new
        d2 = @d2_klass.new
        train d1, @t1_klass
        train d2, @t2_klass
        d1_score = test(d1, @t1_klass) / @testing_txns.size.to_f
        d2_score = test(d2, @t2_klass) / @testing_txns.size.to_f
        winner = if d1_score > d2_score
          @d1_klass.name
        elsif d1_score < d2_score
          @d2_klass.name
        else
          "Draw"
        end
        puts "#{winner} (#{((d1_score - d2_score) * 100).round}%): #{(d1_score * 100).round}% : #{(d2_score * 100).round}%"
      end
    end

    def train(dataset, t_klass)
      @training_txns.each { |h| dataset.train h['category'], t_klass.features(h) }
    end

    def test(dataset, t_klass)
      @testing_txns.select { |e| e['category'] == dataset.classify(t_klass.features e) }.size
    end

  end
end
