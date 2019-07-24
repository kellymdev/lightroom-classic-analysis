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

  context 'calculating frequencies from models' do
    let(:lens_1) { create(:lens) }
    let(:lens_2) { create(:lens, value: 'EF400mm f/5.6L USM') }
    let(:lens_3) { create(:lens, value: 'EF100mm f/2.8 Macro USM') }
    let(:klass_name) { Lens }

    before do
      lens_1
      lens_2
      lens_3
    end

    describe '.calculate_most_frequent_from_model' do
      subject(:calculator) { FrequencyCalculator.calculate_most_frequent_from_model(model_ids, klass_name) }

      context 'when there is one element with the highest frequency' do
        let(:model_ids) { [lens_2.id, lens_1.id, lens_3.id, lens_2.id] }

        it 'returns the value of the highest frequency model' do
          expect(calculator).to eq lens_2.value
        end
      end

      context 'when there is more than one element with the highest frequency' do
        let(:model_ids) { [lens_1.id, lens_2.id, lens_1.id, lens_3.id, lens_2.id] }

        it 'returns the first element with the highest frequency' do
          expect(calculator).to eq lens_1.value
        end
      end
    end

    describe '.calculate_frequently_used_from_model' do
      let(:model_ids) { [lens_1.id, lens_2.id, lens_1.id, lens_3.id] }

      subject(:calculator) { FrequencyCalculator.calculate_frequently_used_from_model(model_ids, klass_name, number_of_results) }

      context 'when there are more than the specified number of results' do
        let(:number_of_results) { 2 }

        it 'returns an array of the most frequently used values up to the required number of results' do
          expect(calculator).to eq [lens_1.value, lens_2.value]
        end
      end

      context 'when there are fewer than the specified number of results' do
        let(:number_of_results) { 5 }

        it 'returns an array of all the values' do
          expect(calculator).to eq [lens_1.value, lens_2.value, lens_3.value]
        end
      end
    end

    describe '.calculate_frequencies_for_model' do
      subject(:calculator) { FrequencyCalculator.calculate_frequencies_for_model(model_ids, klass_name) }

      context 'when the model_ids are present' do
        let(:model_ids) { [lens_2.id, lens_1.id, lens_3.id, lens_3.id] }
        let(:expected_result) do
          {
            lens_2.id => {
              frequency: 1,
              model_name: lens_2.value
            },
            lens_1.id => {
              frequency: 1,
              model_name: lens_1.value
            },
            lens_3.id => {
              frequency: 2,
              model_name: lens_3.value
            }
          }
        end

        it 'returns a list of frequencies for each model id including the model name' do
          expect(calculator).to eq expected_result
        end
      end

      context 'when there is a nil in the model_ids' do
        let(:model_ids) { [lens_1.id, nil] }
        let(:expected_result) do
          {
            lens_1.id => {
              frequency: 1,
              model_name: lens_1.value
            }
          }
        end

        it 'the nil is not included in the results' do
          expect(calculator).to eq expected_result
        end
      end
    end

    describe '.compare_frequencies_by_model_name' do
      let(:frequencies) do
        {
          1 => {
            frequency: 2,
            model_name: 'Canon EOS 5D Mark IV'
          },
          2 => {
            frequency: 4,
            model_name: 'Canon EOS 6D'
          },
          3 => {
            frequency: 3,
            model_name: 'Canon EOS 5D Mark IV'
          }
        }
      end

      let(:expected_result) do
        {
          'Canon EOS 5D Mark IV' => 5,
          'Canon EOS 6D' => 4
        }
      end

      subject(:calculator) { FrequencyCalculator.compare_frequencies_by_model_name(frequencies) }

      it 'returns the frequencies based on the model name' do
        expect(calculator).to eq expected_result
      end
    end
  end

  context 'calculating frequencies for a combination of camera and lens' do
    let(:lens_1) { create(:lens) }
    let(:lens_2) { create(:lens, value: 'EF400mm f/5.6L USM') }

    let(:camera_1) { create(:camera) }
    let(:camera_2) { create(:camera, value: 'Canon EOS 6D') }


    before do
      lens_1
      lens_2
      camera_1
      camera_2
    end

    describe '.calculate_most_frequent_camera_and_lens' do
      let(:camera_lens_ids) { [[camera_1.id, lens_1.id], [camera_2.id, lens_2.id], [camera_2.id, lens_1.id], [camera_2.id, lens_2.id]] }

      subject(:calculator) { FrequencyCalculator.calculate_most_frequent_camera_and_lens(camera_lens_ids) }

      it 'returns the name of the most frequent camera and lens combination' do
        expect(calculator).to eq 'Canon EOS 6D - EF400mm f/5.6L USM'
      end
    end

    describe '.calculate_frequently_used_camera_and_lens' do
      let(:number_of_results) { 3 }
      let(:camera_lens_ids) { [[camera_1.id, lens_1.id], [camera_2.id, lens_2.id], [camera_2.id, lens_1.id], [camera_2.id, lens_2.id]] }

      subject(:calculator) { FrequencyCalculator.calculate_frequently_used_camera_and_lens(camera_lens_ids, number_of_results) }

      it 'returns an array of camera and lens names' do
        expect(calculator).to eq ['Canon EOS 6D - EF400mm f/5.6L USM', 'Canon EOS 5D Mark IV - EF24-105mm f/4L IS USM', 'Canon EOS 6D - EF24-105mm f/4L IS USM']
      end
    end

    describe '.calculate_frequencies_for_camera_and_lens' do
      let(:camera_lens_ids) { [[camera_1.id, lens_1.id], [camera_2.id, lens_2.id], [camera_2.id, lens_1.id], [camera_2.id, lens_2.id]] }

      let(:expected_result) do
        {
          [camera_1.id, lens_1.id] => {
            frequency: 1,
            camera: 'Canon EOS 5D Mark IV',
            lens: 'EF24-105mm f/4L IS USM'
          },
          [camera_2.id, lens_2.id] => {
            frequency: 2,
            camera: 'Canon EOS 6D',
            lens: 'EF400mm f/5.6L USM'
          },
          [camera_2.id, lens_1.id] => {
            frequency: 1,
            camera: 'Canon EOS 6D',
            lens: 'EF24-105mm f/4L IS USM'
          }
        }
      end

      subject(:calculator) { FrequencyCalculator.calculate_frequencies_for_camera_and_lens(camera_lens_ids) }

      it 'returns a list of camera lens combinations with their frequencies' do
        expect(calculator).to eq expected_result
      end
    end

    describe '.group_frequencies_by_camera_and_lens_name' do
      let(:frequencies) do
        {
          [1, 1] => {
            frequency: 1,
            camera: 'Canon EOS 5D Mark IV',
            lens: 'EF24-105mm f/4L IS USM'
          },
          [2, 2] => {
            frequency: 2,
            camera: 'Canon EOS 6D',
            lens: 'EF400mm f/5.6L USM'
          },
          [2, 3] => {
            frequency: 1,
            camera: 'Canon EOS 6D',
            lens: 'EF400mm f/5.6L USM'
          }
        }
      end

      let(:expected_result) do
        {
          'Canon EOS 5D Mark IV - EF24-105mm f/4L IS USM' => 1,
          'Canon EOS 6D - EF400mm f/5.6L USM' => 3
        }
      end

      subject(:calculator) { FrequencyCalculator.group_frequencies_by_camera_and_lens_name(frequencies) }

      it 'groups the frequencies into a hash based on the camera and lens name' do
        expect(calculator).to eq expected_result
      end
    end
  end
end
