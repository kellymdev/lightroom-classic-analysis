require 'rails_helper'

RSpec.describe CalculateDataByCameraAndLens, type: :service do
  describe '#call' do
    let(:camera) { create(:camera, value: camera_name) }
    let(:lens) { create(:lens, value: lens_name) }

    let(:image_1) { create(:image) }
    let(:image_2) { create(:image) }

    let(:exif_1) { create(:exif, cameraModelRef: camera.id, lensRef: lens.id, image: image_1.id) }
    let(:exif_2) { create(:exif, cameraModelRef: camera.id, lensRef: lens.id, image: image_2.id) }
    let(:exif_3) { create(:exif, cameraModelRef: camera.id, lensRef: lens.id) }

    let(:camera_name) { 'Canon EOS 5D Mark IV' }
    let(:lens_name) { 'EF24-105mm f/4L IS USM' }
    let(:year) {}

    subject(:service) { described_class.new(camera_name, lens_name, year) }

    before do
      exif_1
      exif_2
      exif_3
    end

    context 'camera' do
      it 'is the camera name that was passed in' do
        expect(service.call[:camera]).to eq 'Canon EOS 5D Mark IV'
      end
    end

    context 'lens' do
      it 'is the lens name that was passed in' do
        expect(service.call[:lens]).to eq 'EF24-105mm f/4L IS USM'
      end
    end

    context 'when a year is not passed in' do
      context 'years_covered' do
        it 'is All years' do
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

        it 'returns the most frequently used keywords for that camera and lens' do
          expect(service.call[:keywords]).to eq ['kitten', 'cat', 'portrait']
        end
      end

      context 'focal_lengths' do
        before do
          exif_1.update!(focalLength: 25.0)
          exif_2.update!(focalLength: 45.0)
          exif_3.update!(focalLength: 25.0)
        end

        it 'returns the most frequently used focal lengths for that camera and lens' do
          expect(service.call[:focal_lengths]).to eq [25, 45]
        end
      end

      context 'shutter_speeds' do
        before do
          exif_1.update!(shutterSpeed: 10.643856)
        end

        it 'returns the most frequently used shutter speeds for that camera and lens' do
          expect(service.call[:shutter_speeds]).to eq [17, 1600]
        end
      end

      context 'isos' do
        before do
          exif_1.update!(isoSpeedRating: 100.0)
        end

        it 'returns the most frequently used isos for that camera and lens' do
          expect(service.call[:isos]).to eq [1600, 100]
        end
      end

      context 'months' do
        before do
          exif_2.update!(dateMonth: 7.0)
        end

        it 'returns the most frequent months for that camera and lens' do
          expect(service.call[:months]).to eq ['February', 'July']
        end
      end
    end

    context 'when a year is passed in' do
      let(:year) { '2018' }

      before do
        exif_1.update!(dateYear: 2018.0)
        exif_2.update!(dateYear: 2018.0)
        exif_3.update!(dateYear: 2017.0)
      end

      context 'years_covered' do
        it 'is the year passed in' do
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

        it 'returns the most frequently used keywords for that camera, lens and year' do
          expect(service.call[:keywords]).to eq ['kitten', 'cat', 'portrait']
        end
      end

      context 'focal_lengths' do
        before do
          exif_1.update!(focalLength: 200.0)
          exif_2.update!(focalLength: 40.0)
        end

        it 'returns the most frequently used focal lengths for that camera, lens and year' do
          expect(service.call[:focal_lengths]).to eq [200, 40]
        end
      end

      context 'shutter_speeds' do
        before do
          exif_1.update!(shutterSpeed: 10.643856)
        end

        it 'returns the most frequently used shutter speeds for that camera, lens and year' do
          expect(service.call[:shutter_speeds]).to eq [1600, 17]
        end
      end

      context 'isos' do
        before do
          exif_1.update!(isoSpeedRating: 200.0)
        end

        it 'returns the most frequently used isos for that camera, lens and year' do
          expect(service.call[:isos]).to eq [200, 1600]
        end
      end

      context 'months' do
        before do
          exif_1.update!(dateMonth: 9.0)
        end

        it 'returns the most frequent months for that camera, lens and year' do
          expect(service.call[:months]).to eq ['September', 'February']
        end
      end
    end
  end
end