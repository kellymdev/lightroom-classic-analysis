require 'rails_helper'

RSpec.describe CalculateWideAngleLandscapeData, :type => :service do
  describe '#call' do
    let(:camera_1) { create(:camera, value: 'Canon EOS 6D') }
    let(:camera_2) { create(:camera, value: 'Canon EOS 5D Mark IV') }
    let(:lens_1) { create(:lens, value: 'EF24-105mm f/4L IS USM') }
    let(:lens_2) { create(:lens, value: 'EF16-35mm f/4L IS USM') }

    let(:iso) { 100.0 }
    let(:exif_1) { create(:exif, focalLength: 35.0, isoSpeedRating: iso, cameraModelRef: camera_1.id, lensRef: lens_1.id) }
    let(:exif_2) { create(:exif, focalLength: 24.0, isoSpeedRating: iso, cameraModelRef: camera_2.id, lensRef: lens_1.id) }
    let(:exif_3) { create(:exif, focalLength: 16.0, isoSpeedRating: iso, cameraModelRef: camera_2.id, lensRef: lens_2.id) }

    before do
      exif_1
      exif_2
      exif_3
    end

    subject(:service) { described_class.new }

    describe 'cameras' do
      it 'returns the most frequently used cameras for wide angle landscape' do
        expect(service.call[:cameras]).to eq [camera_2.value, camera_1.value]
      end
    end

    describe 'lenses' do
      it 'returns the most frequently used lenses for wide angle landscape' do
        expect(service.call[:lenses]).to eq [lens_1.value, lens_2.value]
      end
    end

    describe 'camera lens combinations' do
      let(:camera_lens_1) { "#{camera_1.value} - #{lens_1.value}" }
      let(:camera_lens_2) { "#{camera_2.value} - #{lens_1.value}" }
      let(:camera_lens_3) { "#{camera_2.value} - #{lens_2.value}" }

      it 'returns the most frequently used camera lens combinations for wide angle landscape' do
        expect(service.call[:camera_lens_combinations]).to eq [camera_lens_1, camera_lens_2, camera_lens_3]
      end
    end

    describe 'focal lengths' do
      before do
        exif_3.update!(focalLength: 35.0)
      end

      it 'returns the most frequently used focal lengths for wide angle landscape' do
        expect(service.call[:focal_lengths]).to eq [35.0, 24.0]
      end
    end

    describe 'shutter speeds' do
      let(:shutter_speed_1) { 5.91 }
      let(:shutter_speed_2) { 7.96 }

      before do
        exif_1.update!(:shutterSpeed => shutter_speed_1)
        exif_2.update!(:shutterSpeed => shutter_speed_2)
        exif_3.update!(:shutterSpeed => shutter_speed_1)
      end

      it 'returns the most frequently used shutter speeds for wide angle landscape' do
        expect(service.call[:shutter_speeds]).to eq [60, 249]
      end
    end

    describe 'month' do
      before do
        exif_1.update!(:dateMonth => 1.0)
        exif_2.update!(:dateMonth => 9.0)
        exif_3.update!(:dateMonth => 9.0)
      end

      it 'returns the most popular month for wide angle landscape' do
        expect(service.call[:month]).to eq 'September'
      end
    end

    describe 'year' do
      before do
        exif_1.update!(:dateYear => 2019.0)
        exif_2.update!(:dateYear => 2018.0)
        exif_3.update!(:dateYear => 2018.0)
      end

      it 'returns the most popular year for wide angle landscape' do
        expect(service.call[:year]).to eq 2018
      end
    end

    describe 'month_year_combinations' do
      before do
        exif_1.update!(:dateMonth => 2.0, :dateYear => 2019.0)
        exif_2.update!(:dateMonth => 5.0, :dateYear => 2018.0)
        exif_3.update!(:dateMonth => 2.0, :dateYear => 2019.0)
      end

      it 'returns the most popular month year combinations for wide angle landscape' do
        expect(service.call[:month_year_combinations]).to eq ['February 2019', 'May 2018']
      end
    end
  end
end
