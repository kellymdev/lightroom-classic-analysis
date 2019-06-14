require 'rails_helper'

RSpec.describe CalculateDataByLens, type: :service do
  describe '#call' do
    let(:lens) { create(:lens) }

    let(:exif_1) { create(:exif, lensRef: lens.id) }
    let(:exif_2) { create(:exif, lensRef: lens.id) }
    let(:exif_3) { create(:exif, lensRef: lens.id) }

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
  end
end
