require 'rails_helper'

RSpec.describe CalculateDataByLens, type: :service do
  describe '#call' do
    let(:lens) { create(:lens) }

    let(:camera_1) { create(:camera, value: 'Canon EOS 6D') }
    let(:camera_2) { create(:camera, value: 'Canon EOS 5D Mark IV') }

    let(:exif_1) { create(:exif, lensRef: lens.id, cameraModelRef: camera_1.id) }
    let(:exif_2) { create(:exif, lensRef: lens.id, cameraModelRef: camera_2.id) }
    let(:exif_3) { create(:exif, lensRef: lens.id, cameraModelRef: camera_2.id) }

    before do
      exif_1
      exif_2
      exif_3
    end

    subject(:service) { described_class.new('EF24-105mm f/4L IS USM') }

    context 'lens_name' do
      it 'is the name of the lens passed in' do
        expect(service.call[:lens]).to eq 'EF24-105mm f/4L IS USM'
      end
    end

    context 'keywords' do
      let(:image_1) { create(:image) }
      let(:image_2) { create(:image) }

      let(:keyword_1) { create(:keyword, lc_name: 'cat') }
      let(:keyword_2) { create(:keyword, lc_name: 'kitten') }
      let(:keyword_3) { create(:keyword, lc_name: 'portrait') }

      let(:keyword_image_1) { create(:keyword_image, image: image_1.id, tag: keyword_1.id) }
      let(:keyword_image_2) { create(:keyword_image, image: image_1.id, tag: keyword_2.id) }
      let(:keyword_image_3) { create(:keyword_image, image: image_1.id, tag: keyword_3.id) }
      let(:keyword_image_4) { create(:keyword_image, image: image_2.id, tag: keyword_2.id) }

      before do
        exif_1.update!(image: image_1.id)
        exif_2.update!(image: image_2.id)

        keyword_image_1
        keyword_image_2
        keyword_image_3
        keyword_image_4
      end

      it 'lists the most frequently used keywords for that lens' do
        expect(service.call[:keywords]).to eq ['kitten', 'cat', 'portrait']
      end
    end

    context 'cameras' do
      it 'lists the most frequently used camera models for that lens' do
        expect(service.call[:cameras]).to eq [camera_2.value, camera_1.value]
      end
    end

    context 'focal_lengths' do
      before do
        exif_1.update!(focalLength: 35.0)
        exif_2.update!(focalLength: 100.0)
        exif_3.update!(focalLength: 35.0)
      end

      it 'lists the most frequently used focal lengths for that lens' do
        expect(service.call[:focal_lengths]).to eq [35, 100]
      end
    end

    context 'shutter_speeds' do
      before do
        exif_1.update!(shutterSpeed: 5.91)
        exif_2.update!(shutterSpeed: 10.643856)
        exif_3.update!(shutterSpeed: 5.91)
      end

      it 'lists the most frequently used shutter speeds for that lens' do
        expect(service.call[:shutter_speeds]).to eq [60, 1600]
      end
    end

    context 'isos' do
      before do
        exif_1.update!(isoSpeedRating: 1600.0)
        exif_2.update!(isoSpeedRating: 100.0)
        exif_3.update!(isoSpeedRating: 100.0)
      end

      it 'lists the most frequently used isos for that lens' do
        expect(service.call[:isos]).to eq [100, 1600]
      end
    end

    context 'months' do
      before do
        exif_1.update!(dateMonth: 5.0)
        exif_2.update!(dateMonth: 8.0)
        exif_3.update!(dateMonth: 8.0)
      end

      it 'lists the most frequent months for that lens' do
        expect(service.call[:months]).to eq ['August', 'May']
      end
    end

    context 'years' do
      before do
        exif_1.update!(dateYear: 2018.0)
        exif_2.update!(dateYear: 2018.0)
        exif_3.update!(dateYear: 2017.0)
      end

      it 'lists the most frequent years for that lens' do
        expect(service.call[:years]).to eq [2018, 2017]
      end
    end

    context 'month year combinations' do
      before do
        exif_1.update!(dateMonth: 5.0, dateYear: 2017.0)
        exif_2.update!(dateMonth: 6.0, dateYear: 2018.0)
        exif_3.update!(dateMonth: 5.0, dateYear: 2017.0)
      end

      it 'lists the most frequent month year combinations for that lens' do
        expect(service.call[:month_year_combinations]).to eq ['May 2017', 'June 2018']
      end
    end
  end
end
