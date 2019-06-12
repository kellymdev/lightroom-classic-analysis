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
  end
end
