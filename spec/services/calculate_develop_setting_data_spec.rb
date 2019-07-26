require 'rails_helper'

RSpec.describe CalculateDevelopSettingData, type: :service do
  describe '#call' do
    let(:develop_step_1) { create(:develop_history_step, name: 'Crop Rectangle', valueString: '7') }
    let(:develop_step_2) { create(:develop_history_step, valueString: '10') }
    let(:develop_step_3) { create(:develop_history_step, valueString: '10') }

    subject(:service) { described_class.new }

    before do
      develop_step_1
      develop_step_2
      develop_step_3
    end

    context 'develop_steps' do
      it 'returns a list of the most popular develop history steps' do
        expect(service.call[:develop_steps]).to eq ['Contrast', 'Crop Rectangle']
      end
    end

    context 'individual develop settings' do
      before do
        develop_step_1.update!(name: step_name)
        develop_step_2.update!(name: step_name)
        develop_step_3.update!(name: step_name)
      end

      context 'exposure' do
        let(:step_name) { 'Exposure' }

        it 'returns a list of the most popular exposure adjustments' do
          expect(service.call[:exposure]).to eq ['10', '7']
        end
      end

      context 'contrast' do
        let(:step_name) { 'Contrast' }

        it 'returns a list of the most popular contrast adjustments' do
          expect(service.call[:contrast]).to eq ['10', '7']
        end
      end

      context 'highlights' do
        let(:step_name) { 'Highlights' }

        it 'returns a list of the most popular highlight adjustments' do
          expect(service.call[:highlights]).to eq ['10', '7']
        end
      end

      context 'shadows' do
        let(:step_name) { 'Shadows' }

        it 'returns a list of the most popular shadows adjustments' do
          expect(service.call[:shadows]).to eq ['10', '7']
        end
      end

      context 'white_clipping' do
        let(:step_name) { 'White Clipping' }

        it 'returns a list of the most popular white clipping adjustments' do
          expect(service.call[:white_clipping]).to eq ['10', '7']
        end
      end

      context 'black clipping' do
        let(:step_name) { 'Black Clipping' }

        it 'returns a list of the most popular black clipping adjustments' do
          expect(service.call[:black_clipping]).to eq ['10', '7']
        end
      end

      context 'clarity' do
        let(:step_name) { 'Clarity' }

         it 'returns a list of the most popular clarity adjustments' do
           expect(service.call[:clarity]).to eq ['10', '7']
         end
      end

      context 'post_crop_vignette_amount' do
        let(:step_name) { 'Post-Crop Vignette Amount' }

        it 'returns a list of the most popular post-crop vignette amount adjustments' do
          expect(service.call[:post_crop_vignette_amount]).to eq ['10', '7']
        end
      end

      context 'vibrance' do
        let(:step_name) { 'Vibrance' }

        it 'returns a list of the most popular vibrance adjustments' do
          expect(service.call[:vibrance]).to eq ['10', '7']
        end
      end

      context 'saturation' do
        let(:step_name) { 'Saturation' }

        it 'returns a list of the most popular saturation adjustments' do
          expect(service.call[:saturation]).to eq ['10', '7']
        end
      end
    end

    context 'average values' do
      before do
        develop_step_1.update!(name: step_name)
        develop_step_2.update!(name: step_name)
        develop_step_3.update!(name: step_name)
      end

      context 'exposure' do
        let(:step_name) { 'Exposure' }

        context 'positive' do
          it 'returns the average positive exposure' do
            expect(service.call[:averages][:positive_exposure]).to eq 9
          end
        end
      end
    end
  end
end
