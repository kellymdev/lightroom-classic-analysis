# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Image, type: :model do
  let(:image) { create(:image) }

  describe 'scopes' do
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

    describe '#for_month' do
      before do
        image.update!(captureTime: '2014-10-25T11:53:43')
      end

      context 'when the image is captured in that month' do
        it 'is included in the results' do
          expect(Image.for_month('10')).to include image
        end
      end

      context 'when the image is not captured in that month' do
        it 'is not included in the results' do
          expect(Image.for_month('09')).not_to include image
        end
      end
    end

    describe '#for_year' do
      before do
        image.update!(captureTime: '2019-10-25T11:53:43')
      end

      context 'when the image is captured in that year' do
        it 'is included in the results' do
          expect(Image.for_year('2019')).to include image
        end
      end

      context 'when the image is not capture in that year' do
        it 'is not included in the results' do
          expect(Image.for_year('2018')).not_to include image
        end
      end
    end
  end

  describe '#capture_hour' do
    before do
      image.update!(captureTime: '2019-10-25T11:53:43')
    end

    it 'returns the hour the image was taken' do
      expect(image.capture_hour).to eq 11
    end
  end
end
