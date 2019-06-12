require 'rails_helper'

RSpec.describe CalculateMostPopularData, type: :service do
  describe '#call' do
    let(:camera_1) { create(:camera) }
    let(:camera_2) { create(:camera, value: 'Canon EOS 6D') }
    let(:lens_1) { create(:lens, value: 'EF24-105mm f/4L IS USM' ) }
    let(:lens_2) { create(:lens, value: 'EF400mm f/5.6L USM') }

    let(:exif) { create(:exif, cameraModelRef: camera_1.id, lensRef: lens_1.id) }
    let(:exif_2) { create(:exif, cameraModelRef: camera_2.id, lensRef: lens_2.id) }
    let(:exif_3) { create(:exif, cameraModelRef: camera_1.id, lensRef: lens_2.id) }

    subject(:service) { described_class.new }

    before do
      exif
      exif_2
      exif_3
    end

    context 'camera' do
      it 'returns the most frequently used camera' do
        expect(service.call[:camera]).to eq camera_1.value
      end

      context 'when there is more than one camera record for the same camera model' do
        let(:camera_3) { create(:camera, value: 'Canon EOS 6D') }
        let(:exif_4) { create(:exif, cameraModelRef: camera_3.id, lensRef: lens_1.id) }
        let(:exif_5) { create(:exif, cameraModelRef: camera_3.id, lensRef: lens_2.id)}

        before do
          exif_4
          exif_5
        end

        it 'groups the camera records together by model' do
          expect(service.call[:camera]).to eq camera_2.value
        end
      end
    end

    context 'lens' do
      it 'returns the most frequently used lens' do
        expect(service.call[:lens]).to eq lens_2.value
      end

      context 'when there is more than one lens record for the same lens model' do
        let(:lens_3) { create(:lens, value: 'EF24-105mm f/4L IS USM') }
        let(:exif_4) { create(:exif, cameraModelRef: camera_1.id, lensRef: lens_3.id) }
        let(:exif_5) { create(:exif, cameraModelRef: camera_2.id, lensRef: lens_3.id) }

        before do
          exif_4
          exif_5
        end

        it 'groups the lens records together by model' do
          expect(service.call[:lens]).to eq lens_1.value
        end
      end
    end
  end
end
