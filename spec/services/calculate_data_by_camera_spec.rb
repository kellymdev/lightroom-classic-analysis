require 'rails_helper'

RSpec.describe CalculateDataByCamera, type: :service do
  describe '#call' do
    let(:camera) { create(:camera) }
    let(:lens_1) { create(:lens, value: 'EF24-105mm f/4L IS USM') }
    let(:lens_2) { create(:lens, value: 'EF400mm f/5.6L USM') }

    let(:image_1) { create(:image) }
    let(:image_2) { create(:image) }

    let(:exif_1) { create(:exif, cameraModelRef: camera.id, lensRef: lens_1.id, image: image_1.id) }
    let(:exif_2) { create(:exif, cameraModelRef: camera.id, lensRef: lens_2.id, image: image_2.id) }
    let(:exif_3) { create(:exif, cameraModelRef: camera.id, lensRef: lens_1.id) }

    before do
      exif_1
      exif_2
      exif_3
    end

    let(:year) { nil }

    subject(:service) { CalculateDataByCamera.new('Canon EOS 5D Mark IV', year) }

    context 'camera' do
      it 'returns the camera name passed in' do
        expect(service.call[:camera]).to eq 'Canon EOS 5D Mark IV'
      end
    end

    context 'when no year is passed in' do
      context 'years_covered' do
        it 'returns All years' do
          expect(service.call[:years_covered]).to eq 'All years'
        end
      end

      context 'keywords' do
        let(:keyword_1) { create(:keyword, lc_name: 'cat') }
        let(:keyword_2) { create(:keyword, lc_name: 'kitten') }
        let(:keyword_3) { create(:keyword, lc_name: 'portrait') }

        let(:keyword_image_1) { create(:keyword_image, image: image_1.id, tag: keyword_1.id) }
        let(:keyword_image_2) { create(:keyword_image, image: image_1.id, tag: keyword_2.id) }
        let(:keyword_image_3) { create(:keyword_image, image: image_1.id, tag: keyword_3.id) }
        let(:keyword_image_4) { create(:keyword_image, image: image_2.id, tag: keyword_2.id) }

        before do
          keyword_image_1
          keyword_image_2
          keyword_image_3
          keyword_image_4
        end

        it 'returns the most frequently used keywords for that camera' do
          expect(service.call[:keywords]).to eq ['kitten', 'cat', 'portrait']
        end
      end

      context 'lenses' do
        it 'returns the most frequently used lenses for that camera' do
          expect(service.call[:lenses]).to eq ['EF24-105mm f/4L IS USM', 'EF400mm f/5.6L USM']
        end
      end

      context 'focal_lengths' do
        before do
          exif_1.update!(focalLength: 200.0)
        end

        it 'returns the most frequently used focal lengths for that camera' do
          expect(service.call[:focal_lengths]).to eq [100, 200]
        end
      end

      context 'shutter_speeds' do
        before do
          exif_1.update!(shutterSpeed: 10.643856)
        end

        it 'returns the most frequently used shutter speeds for that camera' do
          expect(service.call[:shutter_speeds]).to eq [17, 1600]
        end
      end

      context 'isos' do
        before do
          exif_1.update!(isoSpeedRating: 1000)
        end

        it 'returns the most frequently used isos for that camera' do
          expect(service.call[:isos]).to eq [1600, 1000]
        end
      end

      context 'months' do
        before do
          exif_1.update!(dateMonth: 5.0)
        end

        it 'returns the most frequent months for that camera' do
          expect(service.call[:months]).to eq ['February', 'May']
        end
      end

      context 'years' do
        before do
          exif_1.update!(dateYear: 2017.0)
        end

        it 'returns the most frequent years for that camera' do
          expect(service.call[:years]).to eq [2019, 2017]
        end
      end

      context 'month_year_combinations' do
        before do
          exif_1.update!(dateMonth: 4.0, dateYear: 2018.0)
        end

        it 'returns the most frequent month year combinations for that camera' do
          expect(service.call[:month_year_combinations]).to eq ['February 2019', 'April 2018']
        end
      end
    end

    context 'when a year is passed in' do
      let(:year) { '2018' }

      before do
        exif_1.update!(dateYear: 2018.0)
        exif_2.update!(dateYear: 2018.0)
      end

      context 'years_covered' do
        it 'returns the year passed in' do
          expect(service.call[:years_covered]).to eq '2018'
        end
      end

      context 'keywords' do
        let(:keyword_1) { create(:keyword, lc_name: 'cat') }
        let(:keyword_2) { create(:keyword, lc_name: 'kitten') }
        let(:keyword_3) { create(:keyword, lc_name: 'portrait') }

        let(:keyword_image_1) { create(:keyword_image, image: image_1.id, tag: keyword_1.id) }
        let(:keyword_image_2) { create(:keyword_image, image: image_1.id, tag: keyword_2.id) }
        let(:keyword_image_3) { create(:keyword_image, image: image_1.id, tag: keyword_3.id) }
        let(:keyword_image_4) { create(:keyword_image, image: image_2.id, tag: keyword_2.id) }

        before do
          keyword_image_1
          keyword_image_2
          keyword_image_3
          keyword_image_4
        end

        it 'returns keywords for the selected camera and year' do
          expect(service.call[:keywords]).to eq ['kitten', 'cat', 'portrait']
        end
      end

      context 'lenses' do
        it 'returns the most frequently used lenses for that camera and year' do
          expect(service.call[:lenses]).to eq ['EF24-105mm f/4L IS USM', 'EF400mm f/5.6L USM']
        end
      end

      context 'focal_lengths' do
        before do
          exif_1.update!(focalLength: 35.0)
          exif_2.update!(focalLength: 400.0)
        end

        it 'returns the most frequently used focal lengths for that camera and year' do
          expect(service.call[:focal_lengths]).to eq [35, 400]
        end
      end

      context 'shutter_speeds' do
        before do
          exif_1.update!(shutterSpeed: 10.643856)
          exif_2.update!(shutterSpeed: 4.07)
        end

        it 'returns the most frequently used shutter speeds for that camera and year' do
          expect(service.call[:shutter_speeds]).to eq [1600, 17]
        end
      end

      context 'isos' do
        before do
          exif_1.update!(isoSpeedRating: 200.0)
          exif_2.update!(isoSpeedRating: 1000.0)
        end

        it 'returns the most frequently used isos for that camera and year' do
          expect(service.call[:isos]).to eq [200, 1000]
        end
      end

      context 'months' do
        before do
          exif_1.update!(dateMonth: 9.0)
          exif_2.update!(dateMonth: 3.0)
        end

        it 'returns the most frequent months for that camera and lens' do
          expect(service.call[:months]).to eq ['September', 'March']
        end
      end

      context 'years' do
        it 'only returns data for the year passed in' do
          expect(service.call[:years]).to eq [2018]
        end
      end

      context 'month_year_combinations' do
        before do
          exif_1.update!(dateMonth: 11.0)
          exif_2.update!(dateMonth: 5.0)
        end

        it 'only returns data for the year passed in' do
          expect(service.call[:month_year_combinations]).to eq ['November 2018', 'May 2018']
        end
      end
    end
  end
end
