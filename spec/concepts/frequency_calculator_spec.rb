require 'rails_helper'

RSpec.describe FrequencyCalculator, type: :concept do
  describe '.calculate_frequencies' do
    subject(:calculator) { FrequencyCalculator.calculate_frequencies(frequency_data) }

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
end
