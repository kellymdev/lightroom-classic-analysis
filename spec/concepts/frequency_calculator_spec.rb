require 'rails_helper'

RSpec.describe FrequencyCalculator, type: :concept do
  describe '.calculate_most_frequent' do
    subject(:calculator) { FrequencyCalculator.calculate_most_frequent(frequency_data) }

    context 'when there is one element with the highest frequency' do
      let(:frequency_data) { ['A', 'B', 'C', 'B'] }

      it 'returns the element with the highest frequency' do
        expect(calculator).to eq 'B'
      end
    end

    context 'when there is more than one element with the highest frequency' do
      let(:frequency_data) { ['A', 'B', 'A', 'B', 'C'] }

      it 'returns the first element with the highest frequency' do
        expect(calculator).to eq 'A'
      end
    end
  end

  describe '.calculate_frequently_used' do
    let(:frequency_data) { ['A', 'B', 'C', 'B', 'D'] }

    subject(:calculator) { FrequencyCalculator.calculate_frequently_used(frequency_data, number_of_results) }

    context 'when there are more than the specified number of results' do
      let(:number_of_results) { 3 }

      it 'returns an array of the most frequently occurring values up to the required number of results' do
        expect(calculator).to eq ['B', 'A', 'C']
      end
    end

    context 'when there are fewer than the specified number of results' do
      let(:number_of_results) { 5 }

      it 'returns an array of all the values, ordered by frequency' do
        expect(calculator).to eq ['B', 'A', 'C', 'D']
      end
    end
  end

  describe '.calculate_frequencies' do
    subject(:calculator) { FrequencyCalculator.calculate_frequencies(frequency_data) }

    let(:frequency_data) { ['A', 'B', 'C', 'B'] }
    let(:expected_data) do
      {
        'A' => 1,
        'B' => 2,
        'C' => 1
      }
    end

    it 'returns the frequencies of each of the elements' do
      expect(calculator).to eq expected_data
    end
  end
end
