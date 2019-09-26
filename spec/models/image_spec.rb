# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Image, type: :model do
  describe 'scopes' do
    let(:image) { create(:image) }

    describe '#unrated' do
      before do
        image.update!(rating: rating)
      end

      context 'when an image does not have a star rating' do
        let(:rating) {}

        it 'is included in the results' do
          expect(Image.unrated).to include image
        end
      end

      context 'when an image has a star rating' do
        let(:rating) { 4.0 }

        it 'is not included in the results' do
          expect(Image.unrated).not_to include image
        end
      end
    end

    describe '#rated' do
      before do
        image.update!(rating: rating)
      end

      context 'when an image has a star rating' do
        let(:rating) { 5.0 }

        it 'is included in the results' do
          expect(Image.rated).to include image
        end
      end

      context 'when an image does not have a star rating' do
        let(:rating) {}

        it 'is not included in the results' do
          expect(Image.rated).not_to include image
        end
      end
    end

    describe '#with_star_rating' do
      before do
        image.update!(rating: rating)
      end

      context 'when the image has that star rating' do
        let(:rating) { 5.0 }

        it 'is included in the results' do
          expect(Image.with_star_rating(5.0)).to include image
        end
      end

      context 'when the image has a different star rating' do
        let(:rating) { 4.0 }

        it 'is not included in the results' do
          expect(Image.with_star_rating(5.0)).not_to include image
        end
      end

      context 'when the image is unrated' do
        let(:rating) {}

        it 'is not included in the results' do
          expect(Image.with_star_rating(5.0)).not_to include image
        end
      end
    end
  end
end
