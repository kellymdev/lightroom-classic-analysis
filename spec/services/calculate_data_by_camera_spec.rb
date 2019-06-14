require 'rails_helper'

RSpec.describe CalculateDataByCamera, type: :service do
  describe '#call' do
    let(:camera) { create(:camera) }

    let(:image_1) { create(:image) }
    let(:image_2) { create(:image) }

    let(:exif_1) { create(:exif, cameraModelRef: camera.id, image: image_1.id) }
    let(:exif_2) { create(:exif, cameraModelRef: camera.id, image: image_2.id) }
    let(:exif_3) { create(:exif, cameraModelRef: camera.id) }

    before do
      exif_1
      exif_2
      exif_3
    end

    subject(:service) { CalculateDataByCamera.new('Canon EOS 5D Mark IV') }

    context 'camera' do
      it 'returns the camera name passed in' do
        expect(service.call[:camera]).to eq 'Canon EOS 5D Mark IV'
      end
    end

    context 'keywords' do
      let(:keyword_1) { create(:keyword, lc_name: 'cat') }
      let(:keyword_2) { create(:keyword, lc_name: 'kitten') }
      let(:keyword_3) { create(:keyword, lc_name: 'portrait') }

      let(:keyword_image_1) { create(:keyword_image, image: image_1.id, tag: keyword_1.id) }
      let(:keyword_image_2) { create(:keyword_image, image: image_1.id, tag: keyword_2.id) }
      let(:keyword_image_3) { create(:keyword_image, image: image_1.id, tag: keyword_3.id) }
      let(:keyword_image_4) { create(:keyword_image, image: image_2.id, tag: keyword_1.id) }

      before do
        keyword_image_1
        keyword_image_2
        keyword_image_3
        keyword_image_4
      end

      it 'returns the most frequently used keywords for that camera' do
        expect(service.call[:keywords]).to eq ['cat', 'kitten', 'portrait']
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
  end
end
