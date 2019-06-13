require 'rails_helper'

RSpec.describe KeywordImage, type: :model do
  describe 'scopes' do
    describe 'by_image' do
      let(:image_1) { create(:image) }
      let(:keyword_image) { create(:keyword_image, image: image_1.id) }

      before do
        keyword_image
      end

      context 'with a single image id' do
        context 'when the image id matches the value passed in' do
          it 'is included in the results' do
            expect(KeywordImage.by_image(image_1.id)).to include keyword_image
          end
        end

        context 'when the image id does not match the value passed in' do
          it 'is not included in the results' do
            expect(KeywordImage.by_image(0)).not_to include keyword_image
          end
        end
      end

      context 'with multiple image ids' do
        let(:image_2) { create(:image) }
        let(:keyword_image_2) { create(:keyword_image, image: image_2.id) }

        before do
          keyword_image_2
        end

        it 'includes results for all image ids' do
          results = KeywordImage.by_image([image_1.id, image_2.id])

          expect(results).to include keyword_image
          expect(results).to include keyword_image_2
        end
      end
    end
  end
end
