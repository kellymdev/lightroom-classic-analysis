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
          expect(service.call[:exposure]).to eq %w[10 7]
        end
      end

      context 'contrast' do
        let(:step_name) { 'Contrast' }

        it 'returns a list of the most popular contrast adjustments' do
          expect(service.call[:contrast]).to eq %w[10 7]
        end
      end

      context 'highlights' do
        let(:step_name) { 'Highlights' }

        it 'returns a list of the most popular highlight adjustments' do
          expect(service.call[:highlights]).to eq %w[10 7]
        end
      end

      context 'shadows' do
        let(:step_name) { 'Shadows' }

        it 'returns a list of the most popular shadows adjustments' do
          expect(service.call[:shadows]).to eq %w[10 7]
        end
      end

      context 'white_clipping' do
        let(:step_name) { 'White Clipping' }

        it 'returns a list of the most popular white clipping adjustments' do
          expect(service.call[:white_clipping]).to eq %w[10 7]
        end
      end

      context 'black clipping' do
        let(:step_name) { 'Black Clipping' }

        it 'returns a list of the most popular black clipping adjustments' do
          expect(service.call[:black_clipping]).to eq %w[10 7]
        end
      end

      context 'clarity' do
        let(:step_name) { 'Clarity' }

        it 'returns a list of the most popular clarity adjustments' do
          expect(service.call[:clarity]).to eq %w[10 7]
        end
      end

      context 'post_crop_vignette_amount' do
        let(:step_name) { 'Post-Crop Vignette Amount' }

        it 'returns a list of the most popular post-crop vignette amount adjustments' do
          expect(service.call[:post_crop_vignette_amount]).to eq %w[10 7]
        end
      end

      context 'vibrance' do
        let(:step_name) { 'Vibrance' }

        it 'returns a list of the most popular vibrance adjustments' do
          expect(service.call[:vibrance]).to eq %w[10 7]
        end
      end

      context 'saturation' do
        let(:step_name) { 'Saturation' }

        it 'returns a list of the most popular saturation adjustments' do
          expect(service.call[:saturation]).to eq %w[10 7]
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
          it 'returns the average positive exposure adjustment' do
            expect(service.call[:averages][:positive_exposure]).to eq 9
          end
        end

        context 'negative' do
          before do
            develop_step_1.update!(valueString: '-0.5')
            develop_step_2.update!(valueString: '-0.9')
            develop_step_3.update!(valueString: '-0.1')
          end

          it 'returns the average negative exposure adjustment' do
            expect(service.call[:averages][:negative_exposure]).to eq(-0.5)
          end
        end
      end

      context 'contrast' do
        let(:step_name) { 'Contrast' }

        context 'positive' do
          it 'returns the average positive contrast adjustment' do
            expect(service.call[:averages][:positive_contrast]).to eq 9
          end
        end

        context 'negative' do
          before do
            develop_step_1.update!(valueString: '-5')
            develop_step_2.update!(valueString: '-9')
            develop_step_3.update!(valueString: '-1')
          end

          it 'returns the average negative contrast adjustment' do
            expect(service.call[:averages][:negative_contrast]).to eq(-5)
          end
        end
      end

      context 'highlights' do
        let(:step_name) { 'Highlights' }

        context 'positive' do
          it 'returns the average positive highlights adjustment' do
            expect(service.call[:averages][:positive_highlights]).to eq 9
          end
        end

        context 'negative' do
          before do
            develop_step_1.update!(valueString: '-5')
            develop_step_2.update!(valueString: '-9')
            develop_step_3.update!(valueString: '-1')
          end

          it 'returns the average negative highlights adjustment' do
            expect(service.call[:averages][:negative_highlights]).to eq(-5)
          end
        end
      end

      context 'shadows' do
        let(:step_name) { 'Shadows' }

        context 'positive' do
          it 'returns the average positive shadows adjustment' do
            expect(service.call[:averages][:positive_shadows]).to eq 9
          end
        end

        context 'negative' do
          before do
            develop_step_1.update!(valueString: '-5')
            develop_step_2.update!(valueString: '-9')
            develop_step_3.update!(valueString: '-1')
          end

          it 'returns the average negative shadows adjustment' do
            expect(service.call[:averages][:negative_shadows]).to eq(-5)
          end
        end
      end

      context 'white clipping' do
        let(:step_name) { 'White Clipping' }

        context 'positive' do
          it 'returns the average positive white clipping adjustment' do
            expect(service.call[:averages][:positive_white_clipping]).to eq 9
          end
        end

        context 'negative' do
          before do
            develop_step_1.update!(valueString: '-5')
            develop_step_2.update!(valueString: '-9')
            develop_step_3.update!(valueString: '-1')
          end

          it 'returns the average negative white clipping adjustment' do
            expect(service.call[:averages][:negative_white_clipping]).to eq(-5)
          end
        end
      end

      context 'black clipping' do
        let(:step_name) { 'Black Clipping' }

        context 'positive' do
          it 'returns the average positive black clipping adjustment' do
            expect(service.call[:averages][:positive_black_clipping]).to eq 9
          end
        end

        context 'negative' do
          before do
            develop_step_1.update!(valueString: '-5')
            develop_step_2.update!(valueString: '-9')
            develop_step_3.update!(valueString: '-1')
          end

          it 'returns the average negative black clipping adjustment' do
            expect(service.call[:averages][:negative_black_clipping]).to eq(-5)
          end
        end
      end

      context 'clarity' do
        let(:step_name) { 'Clarity' }

        context 'positive' do
          it 'returns the average positive clarity adjustment' do
            expect(service.call[:averages][:positive_clarity]).to eq 9
          end
        end

        context 'negative' do
          before do
            develop_step_1.update!(valueString: '-5')
            develop_step_2.update!(valueString: '-9')
            develop_step_3.update!(valueString: '-1')
          end

          it 'returns the average negative clarity adjustment' do
            expect(service.call[:averages][:negative_clarity]).to eq(-5)
          end
        end
      end

      context 'post crop vignette amount' do
        let(:step_name) { 'Post-Crop Vignette Amount' }

        context 'positive' do
          it 'returns the average positive post crop vignette amount adjustment' do
            expect(service.call[:averages][:positive_post_crop_vignette_amount]).to eq 9
          end
        end

        context 'negative' do
          before do
            develop_step_1.update!(valueString: '-5')
            develop_step_2.update!(valueString: '-9')
            develop_step_3.update!(valueString: '-1')
          end

          it 'returns the average negative post crop vignette amount adjustment' do
            expect(service.call[:averages][:negative_post_crop_vignette_amount]).to eq(-5)
          end
        end
      end

      context 'vibrance' do
        let(:step_name) { 'Vibrance' }

        context 'positive' do
          it 'returns the average positive vibrance adjustment' do
            expect(service.call[:averages][:positive_vibrance]).to eq 9
          end
        end

        context 'negative' do
          before do
            develop_step_1.update!(valueString: '-5')
            develop_step_2.update!(valueString: '-9')
            develop_step_3.update!(valueString: '-1')
          end

          it 'returns the average negative vibrance amount' do
            expect(service.call[:averages][:negative_vibrance]).to eq(-5)
          end
        end
      end

      context 'saturation' do
        let(:step_name) { 'Saturation' }

        context 'positive' do
          it 'returns the average positive saturation adjustment' do
            expect(service.call[:averages][:positive_saturation]).to eq 9
          end
        end

        context 'negative' do
          before do
            develop_step_1.update!(valueString: '-5')
            develop_step_2.update!(valueString: '-9')
            develop_step_3.update!(valueString: '-1')
          end

          it 'returns the average negative saturation adjustment' do
            expect(service.call[:averages][:negative_saturation]).to eq(-5)
          end
        end
      end
    end
  end
end
