require 'rails_helper'

RSpec.describe CalculateWildlifeData, type: :service do
  describe '#call' do
    let(:exif_1) { create(:exif, focalLength: 350.0) }
    let(:exif_2) { create(:exif, focalLength: 400.0) }
    let(:exif_3) { create(:exif, focalLength: 400.0) }

    subject(:service) { described_class.new }

    before do
      exif_1
      exif_2
      exif_3
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
