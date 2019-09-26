# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculateRatingsData, type: :service do
  describe '#call' do
    let(:image_1) { create(:image, rating: nil) }
    let(:image_2) { create(:image, rating: 3.0) }
    let(:image_3) { create(:image, rating: 4.0) }
    let(:image_scope) { Image.all }

    subject(:service) { CalculateRatingsData.new(image_scope) }

    before do
      image_1
      image_2
      image_3
    end

    context 'unrated' do
      before do
        image_3.update!(rating: nil)
      end

      context 'rating' do
        it 'is Unrated' do
          expect(service.call[:unrated][:rating]).to eq 'Unrated'
        end
      end

      context 'count' do
        it 'is the total number of unrated images' do
          expect(service.call[:unrated][:count]).to eq 2
        end
      end

      context 'percentage' do
        it 'is the percentage of unrated images' do
          expect(service.call[:unrated][:percentage]).to eq 66.67
        end
      end
    end

    context 'one star' do
      before do
        image_1.update!(rating: 1.0)
        image_2. update!(rating: 1.0)
      end

      context 'rating' do
        it 'is 1 star' do
          expect(service.call[:one_star][:rating]).to eq '1 star'
        end
      end

      context 'count' do
        it 'is the total number of images with 1 star' do
          expect(service.call[:one_star][:count]).to eq 2
        end
      end

      context 'percentage' do
        it 'is the percentage of images with 1 star' do
          expect(service.call[:one_star][:percentage]).to eq 66.67
        end
      end
    end

    context 'two stars' do
      before do
        image_1.update!(rating: 2.0)
        image_2.update!(rating: 2.0)
      end

      context 'rating' do
        it 'is 2 stars' do
          expect(service.call[:two_stars][:rating]).to eq '2 stars'
        end
      end

      context 'count' do
        it 'is the total number of images with 2 stars' do
          expect(service.call[:two_stars][:count]).to eq 2
        end
      end

      context 'percentage' do
        it 'is the percentage of images with 2 stars' do
          expect(service.call[:two_stars][:percentage]).to eq 66.67
        end
      end
    end

    context 'three stars' do
      before do
        image_1.update!(rating: 3.0)
      end

      context 'rating' do
        it 'is 3 stars' do
          expect(service.call[:three_stars][:rating]).to eq '3 stars'
        end
      end

      context 'count' do
        it 'is the total number of images with 3 stars' do
          expect(service.call[:three_stars][:count]).to eq 2
        end
      end

      context 'percentage' do
        it 'is the percentage of images with 3 stars' do
          expect(service.call[:three_stars][:percentage]).to eq 66.67
        end
      end
    end

    context 'four stars' do
      before do
        image_1.update!(rating: 4.0)
      end

      context 'rating' do
        it 'is 4 stars' do
          expect(service.call[:four_stars][:rating]).to eq '4 stars'
        end
      end

      context 'count' do
        it 'is the total number of images with 4 stars' do
          expect(service.call[:four_stars][:count]).to eq 2
        end
      end

      context 'percentage' do
        it 'is the percentage of images with 4 stars' do
          expect(service.call[:four_stars][:percentage]).to eq 66.67
        end
      end
    end

    context 'five stars' do
      before do
        image_1.update!(rating: 5.0)
        image_2.update!(rating: 5.0)
      end

      context 'rating' do
        it 'is 5 stars' do
          expect(service.call[:five_stars][:rating]).to eq '5 stars'
        end
      end

      context 'count' do
        it 'is the total number of images with 5 stars' do
          expect(service.call[:five_stars][:count]).to eq 2
        end
      end

      context 'percentage' do
        it 'is the percentage of images with 5 stars' do
          expect(service.call[:five_stars][:percentage]).to eq 66.67
        end
      end
    end

    context 'when there is no data' do
      let(:expected_data) do
        {
          unrated: {
            rating: 'Unrated',
            count: 0,
            percentage: 0.0
          },
          one_star: {
            rating: '1 star',
            count: 0,
            percentage: 0.0
          },
          two_stars: {
            rating: '2 stars',
            count: 0,
            percentage: 0.0
          },
          three_stars: {
            rating: '3 stars',
            count: 0,
            percentage: 0.0
          },
          four_stars: {
            rating: '4 stars',
            count: 0,
            percentage: 0.0
          },
          five_stars: {
            rating: '5 stars',
            count: 0,
            percentage: 0.0
          }
        }
      end

      before do
        Image.destroy_all
      end

      it 'displays all ratings and percentages as 0' do
        expect(service.call).to eq expected_data
      end
    end
  end
end
