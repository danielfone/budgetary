require 'classifier/txn_dataset'
require 'csv'

module Budgetary::Classifier
  RSpec.describe TxnDataset do
    # Do expensize JSON load once
    before(:all) { @data = JSON.load File.read "spec/data/txn-training.json" }

    let(:dataset) { described_class.new }
    let(:training_txns) { @data[0..2000] } # ~ 70% training
    let(:testing_txns) { @data[2000..2100] } # ~ 30% test

    before do
      training_txns.each { |h| dataset.train h['category'], h }
    end

    it 'should have a 95% success rate on sample data' do
      correct_count = testing_txns.select { |t| p c = dataset.classify(t); c == t['category'] }.size
      @correct_ratio = (correct_count / testing_txns.size.to_f).round(3)

      expect(@correct_ratio).to be > 0.95
    end

    it "should return multiple classes if there's high uncertainty"

  end
end

