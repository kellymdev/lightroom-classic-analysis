# frozen_string_literal: true

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
      let(:expected_data) do
        [
          {
            value: 'Contrast',
            percentage: 66.67
          },
          {
            value: 'Crop Rectangle',
            percentage: 33.33
          }
        ]
      end

      it 'returns a list of the most popular develop history steps' do
        expect(service.call[:develop_steps]).to eq expected_data
      end
    end

    context 'individual develop steps' do
      let(:expected_data) do
        [
          {
            value: '10',
            percentage: 66.67
          },
          {
            value: '7',
            percentage: 33.33
          }
        ]
      end

      before do
        develop_step_1.update!(name: step_name)
        develop_step_2.update!(name: step_name)
        develop_step_3.update!(name: step_name)
      end

      context 'exposure' do
        let(:step_name) { 'Exposure' }

        context 'most_frequent' do
          it 'returns a list of the most popular exposure adjustments' do
            expect(service.call[:exposure][:most_frequent]).to eq expected_data
          end
        end

        context 'positive' do
          it 'returns the average positive exposure adjustment' do
            expect(service.call[:exposure][:positive]).to eq 9
          end
        end

        context 'negative' do
          before do
            develop_step_1.update!(valueString: '-0.5')
            develop_step_2.update!(valueString: '-0.9')
            develop_step_3.update!(valueString: '-0.1')
          end

          it 'returns the average negative exposure adjustment' do
            expect(service.call[:exposure][:negative]).to eq(-0.5)
          end
        end
      end

      context 'contrast' do
        let(:step_name) { 'Contrast' }

        context 'most_frequent' do
          it 'returns a list of the most popular contrast adjustments' do
            expect(service.call[:contrast][:most_frequent]).to eq expected_data
          end
        end

        context 'positive' do
          it 'returns the average positive contrast adjustment' do
            expect(service.call[:contrast][:positive]).to eq 9
          end
        end

        context 'negative' do
          before do
            develop_step_1.update!(valueString: '-5')
            develop_step_2.update!(valueString: '-9')
            develop_step_3.update!(valueString: '-1')
          end

          it 'returns the average negative contrast adjustment' do
            expect(service.call[:contrast][:negative]).to eq(-5)
          end
        end
      end

      context 'highlights' do
        let(:step_name) { 'Highlights' }

        context 'most frequent' do
          it 'returns a list of the most popular highlight adjustments' do
            expect(service.call[:highlights][:most_frequent]).to eq expected_data
          end
        end

        context 'positive' do
          it 'returns the average positive highlights adjustment' do
            expect(service.call[:highlights][:positive]).to eq 9
          end
        end

        context 'negative' do
          before do
            develop_step_1.update!(valueString: '-5')
            develop_step_2.update!(valueString: '-9')
            develop_step_3.update!(valueString: '-1')
          end

          it 'returns the average negative highlights adjustment' do
            expect(service.call[:highlights][:negative]).to eq(-5)
          end
        end
      end

      context 'shadows' do
        let(:step_name) { 'Shadows' }

        context 'most_frequent' do
          it 'returns a list of the most popular shadows adjustments' do
            expect(service.call[:shadows][:most_frequent]).to eq expected_data
          end
        end

        context 'positive' do
          it 'returns the average positive shadows adjustment' do
            expect(service.call[:shadows][:positive]).to eq 9
          end
        end

        context 'negative' do
          before do
            develop_step_1.update!(valueString: '-5')
            develop_step_2.update!(valueString: '-9')
            develop_step_3.update!(valueString: '-1')
          end

          it 'returns the average negative shadows adjustment' do
            expect(service.call[:shadows][:negative]).to eq(-5)
          end
        end
      end

      context 'white_clipping' do
        let(:step_name) { 'White Clipping' }

        context 'most frequent' do
          it 'returns a list of the most popular white clipping adjustments' do
            expect(service.call[:white_clipping][:most_frequent]).to eq expected_data
          end
        end

        context 'positive' do
          it 'returns the average positive white clipping adjustment' do
            expect(service.call[:white_clipping][:positive]).to eq 9
          end
        end

        context 'negative' do
          before do
            develop_step_1.update!(valueString: '-5')
            develop_step_2.update!(valueString: '-9')
            develop_step_3.update!(valueString: '-1')
          end

          it 'returns the average negative white clipping adjustment' do
            expect(service.call[:white_clipping][:negative]).to eq(-5)
          end
        end
      end

      context 'black clipping' do
        let(:step_name) { 'Black Clipping' }

        context 'most frequent' do
          it 'returns a list of the most popular black clipping adjustments' do
            expect(service.call[:black_clipping][:most_frequent]).to eq expected_data
          end
        end

        context 'positive' do
          it 'returns the average positive black clipping adjustment' do
            expect(service.call[:black_clipping][:positive]).to eq 9
          end
        end

        context 'negative' do
          before do
            develop_step_1.update!(valueString: '-5')
            develop_step_2.update!(valueString: '-9')
            develop_step_3.update!(valueString: '-1')
          end

          it 'returns the average negative black clipping adjustment' do
            expect(service.call[:black_clipping][:negative]).to eq(-5)
          end
        end
      end

      context 'Texture' do
        let(:step_name) { 'Texture' }

        context 'most_frequent' do
          it 'returns a list of the most popular texture adjustments' do
            expect(service.call[:texture][:most_frequent]).to eq expected_data
          end
        end

        context 'positive' do
          it 'returns the average positive texture adjustment' do
            expect(service.call[:texture][:positive]).to eq 9
          end
        end

        context 'negative' do
          before do
            develop_step_1.update!(valueString: '-5')
            develop_step_2.update!(valueString: '-9')
            develop_step_3.update!(valueString: '-1')
          end

          it 'returns the average negative texture adjustment' do
            expect(service.call[:texture][:negative]).to eq(-5)
          end
        end
      end

      context 'clarity' do
        let(:step_name) { 'Clarity' }

        context 'most frequent' do
          it 'returns a list of the most popular clarity adjustments' do
            expect(service.call[:clarity][:most_frequent]).to eq expected_data
          end
        end

        context 'positive' do
          it 'returns the average positive clarity adjustment' do
            expect(service.call[:clarity][:positive]).to eq 9
          end
        end

        context 'negative' do
          before do
            develop_step_1.update!(valueString: '-5')
            develop_step_2.update!(valueString: '-9')
            develop_step_3.update!(valueString: '-1')
          end

          it 'returns the average negative clarity adjustment' do
            expect(service.call[:clarity][:negative]).to eq(-5)
          end
        end
      end

      context 'dehaze' do
        let(:step_name) { 'Dehaze Amount' }

        context 'most frequent' do
          it 'returns a list of the most populate dehaze adjustments' do
            expect(service.call[:dehaze][:most_frequent]).to eq expected_data
          end
        end

        context 'positive' do
          it 'returns the average positive dehaze adjustment' do
            expect(service.call[:dehaze][:positive]).to eq 9
          end
        end

        context 'negative' do
          before do
            develop_step_1.update!(valueString: '-5')
            develop_step_2.update!(valueString: '-9')
            develop_step_3.update!(valueString: '-1')
          end

          it 'returns the average negative dehaze adjustment' do
            expect(service.call[:dehaze][:negative]).to eq(-5)
          end
        end
      end

      context 'post_crop_vignette_amount' do
        let(:step_name) { 'Post-Crop Vignette Amount' }

        context 'most popular' do
          it 'returns a list of the most popular post-crop vignette amount adjustments' do
            expect(service.call[:post_crop_vignette_amount][:most_frequent]).to eq expected_data
          end
        end

        context 'positive' do
          it 'returns the average positive post crop vignette amount adjustment' do
            expect(service.call[:post_crop_vignette_amount][:positive]).to eq 9
          end
        end

        context 'negative' do
          before do
            develop_step_1.update!(valueString: '-5')
            develop_step_2.update!(valueString: '-9')
            develop_step_3.update!(valueString: '-1')
          end

          it 'returns the average negative post crop vignette amount adjustment' do
            expect(service.call[:post_crop_vignette_amount][:negative]).to eq(-5)
          end
        end
      end

      context 'vibrance' do
        let(:step_name) { 'Vibrance' }

        context 'most frequent' do
          it 'returns a list of the most popular vibrance adjustments' do
            expect(service.call[:vibrance][:most_frequent]).to eq expected_data
          end
        end

        context 'positive' do
          it 'returns the average positive vibrance adjustment' do
            expect(service.call[:vibrance][:positive]).to eq 9
          end
        end

        context 'negative' do
          before do
            develop_step_1.update!(valueString: '-5')
            develop_step_2.update!(valueString: '-9')
            develop_step_3.update!(valueString: '-1')
          end

          it 'returns the average negative vibrance amount' do
            expect(service.call[:vibrance][:negative]).to eq(-5)
          end
        end
      end

      context 'saturation' do
        let(:step_name) { 'Saturation' }

        context 'most frequent' do
          it 'returns a list of the most popular saturation adjustments' do
            expect(service.call[:saturation][:most_frequent]).to eq expected_data
          end
        end

        context 'positive' do
          it 'returns the average positive saturation adjustment' do
            expect(service.call[:saturation][:positive]).to eq 9
          end
        end

        context 'negative' do
          before do
            develop_step_1.update!(valueString: '-5')
            develop_step_2.update!(valueString: '-9')
            develop_step_3.update!(valueString: '-1')
          end

          it 'returns the average negative saturation adjustment' do
            expect(service.call[:saturation][:negative]).to eq(-5)
          end
        end
      end
    end

    context 'develop setting data' do
      let(:develop_setting_1) { create(:develop_setting) }
      let(:develop_setting_2) { create(:develop_setting) }
      let(:develop_setting_3) { create(:develop_setting) }

      context 'white_balance' do
        let(:expected_data) do
          [
            {
              value: 'Custom',
              percentage: 66.67
            },
            {
              value: 'As Shot',
              percentage: 33.33
            }
          ]
        end

        before do
          develop_setting_1.update!(whiteBalance: 'As Shot')
          develop_setting_2.update!(whiteBalance: 'Custom')
          develop_setting_3.update!(whiteBalance: 'Custom')
        end

        it 'returns a list of the most popular white balance settings' do
          expect(service.call[:white_balance]).to eq expected_data
        end
      end

      context 'crop_ratios' do
        let(:expected_data) do
          [
            {
              value: '3 x 2',
              percentage: 66.67
            },
            {
              value: '1 x 1',
              percentage: 33.33
            }
          ]
        end

        before do
          develop_setting_1.update!(croppedWidth: 4441.0, croppedHeight: 2961.0)
          develop_setting_2.update!(croppedWidth: 5240.0, croppedHeight: 3493.0)
          develop_setting_3.update!(croppedWidth: 3275.0, croppedHeight: 3314.0)
        end

        it 'returns a list of the most popular crop ratios' do
          expect(service.call[:crop_ratios]).to eq expected_data
        end
      end

      context 'process_version' do
        let(:expected_data) do
          [
            {
              value: 6.7,
              percentage: 66.67
            },
            {
              value: 11.0,
              percentage: 33.33
            }
          ]
        end

        before do
          develop_setting_1.update!(processVersion: 6.7)
          develop_setting_2.update!(processVersion: 11.0)
          develop_setting_3.update!(processVersion: 6.7)
        end

        it 'returns a list of the most popular process versions' do
          expect(service.call[:process_versions]).to eq expected_data
        end
      end
    end
  end
end
