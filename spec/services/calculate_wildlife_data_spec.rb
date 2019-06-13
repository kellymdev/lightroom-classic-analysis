require 'rails_helper'

RSpec.describe CalculateWildlifeData, type: :service do
  describe '#call' do
    let(:camera_1) { create(:camera, value: 'Canon EOS 7D') }
    let(:camera_2) { create(:camera, value: 'Canon EOS 5D Mark IV') }
    let(:lens_1) { create(:lens, value: 'EF300mm f/2.8L USM') }
    let(:lens_2) { create(:lens, value: 'EF400mm f/5.6L USM') }

    let(:exif_1) { create(:exif, cameraModelRef: camera_1.id, lensRef: lens_1.id, focalLength: 350.0) }
    let(:exif_2) { create(:exif, cameraModelRef: camera_2.id, lensRef: lens_2.id, focalLength: 400.0) }
    let(:exif_3) { create(:exif, cameraModelRef: camera_1.id, lensRef: lens_2.id, focalLength: 400.0) }

    subject(:service) { described_class.new }

    before do
      exif_1
      exif_2
      exif_3
    end

    context 'cameras' do
      it 'returns the most frequently used cameras for wildlife' do
        expect(service.call[:cameras]).to eq [camera_1.value, camera_2.value]
      end
    end

    context 'lenses' do
      it 'retuns the most frequently used lenses for wildlife' do
        expect(service.call[:lenses]).to eq [lens_2.value, lens_1.value]
      end
    end

    context 'focal lengths' do
      it 'returns the most frequently used focal lengths for wildlife' do
        expect(service.call[:focal_lengths]).to eq [400, 350]
      end
    end

    context 'isos' do
      before do
        exif_1.update!(isoSpeedRating: 100.0)
      end

      it 'returns the most frequently used isos for wildlife' do
        expect(service.call[:isos]).to eq [1600, 100]
      end
    end

    context 'shutter speeds' do
      let(:shutter_speed_1) { 12.643856 }
      let(:shutter_speed_2) { 10.643856 }

      before do
        exif_1.update!(shutterSpeed: shutter_speed_1)
        exif_2.update!(shutterSpeed: shutter_speed_2)
        exif_3.update!(shutterSpeed: shutter_speed_2)
      end

      it 'returns the most frequently used shutter speeds for wildlife' do
        expect(service.call[:shutter_speeds]).to eq [1600, 6400]
      end
    end

    context 'month' do
      before do
        exif_2.update!(dateMonth: 11.0)
      end

      it 'returns the most frequent month for wildlife images' do
        expect(service.call[:month]).to eq 'February'
      end
    end

    context 'year' do
      before do
        exif_2.update!(dateYear: 2017.0)
      end

      it 'returns the most frequent year for wildlife images' do
        expect(service.call[:year]).to eq 2019
      end
    end
  end
end
