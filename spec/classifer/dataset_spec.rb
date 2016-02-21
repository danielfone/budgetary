require 'classifier/txn_dataset'
require 'csv'

module Budgetary::Classifier
  RSpec.describe TxnDataset do

    before :all do
      data = JSON.load File.read "spec/data/txn-training.json"
      @dataset = described_class.new
      data[0..2000].each { |h| @dataset.train h['category'], h }
      testing_txns = data[2000..2100]

      # Classify and compare with known answers
      correct_count = 0
      @classifications = Set.new
      testing_txns.each do |txn|
        classification = @dataset.classify txn
        @classifications.add classification
        correct_count += 1 if classification == txn['category']
      end
      pp testing_txns.size
      @correct_ratio = (correct_count / testing_txns.size.to_f).round(3)
    end

    # load JSON
    # randomly partition into 70% training, 30% test
    # ^ nope, don't like non-deterministic test-suites
    # instead, predefine partitions ensuring both training and test have similar priors (i.e. similar proportions of each category)
    # We can recombine and randomly partition dataset when we're specifically looking for improvements in the classifer

    # given this is non-deterministic, hmmm…
    it 'should have a 95% success rate on sample data' do
      expect(@correct_ratio).to be > 0.95
    end

    it 'should only return options from current known classes' do
      expect(@dataset.categories).to include *@classifications
    end

    it "should return multiple classes if there's high uncertainty"

  end
end

