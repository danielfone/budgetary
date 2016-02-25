require 'csv'

module Classifier
  RSpec.describe Dataset do
    # Do expensize JSON load once
    before(:all) { @data = JSON.load(File.read "spec/data/txn-training.json") }

    let(:dataset) { described_class.new }
    let(:training_txns) { @data[0..1960] } # ~ 70% training
    let(:testing_txns) { @data[1960..-1] } # ~ 30% test

    before do
      training_txns.each { |h| dataset.train h['category'], Txn.features(h) }
    end

    it 'should have a reasonable success rate on sample data' do
      results = testing_txns.each_with_object(Hash.new 0) do |attrs, h|
        c = dataset.classify Txn.features attrs
        if !c
          h[:blank] += 1
        elsif c == attrs['category']
          h[:correct] += 1
        else
          h[:wrong] += 1
          #puts "guessed: #{c.inspect} != actual: #{attrs['category'].inspect}\n\t#{attrs.inspect}\n\n"
        end
      end

      @correct_ratio = (results[:correct] / testing_txns.size.to_f).round(3)
      @wrong_ratio = (results[:wrong] / testing_txns.size.to_f).round(3)
      @blank_ratio = (results[:blank] / testing_txns.size.to_f).round(3)
      expect(@correct_ratio).to be > 0.9
      expect(@wrong_ratio).to be < 0.3
      expect(@blank_ratio).to be < 0.1
    end

    it "should return multiple classes if there's high uncertainty"

  end
end

