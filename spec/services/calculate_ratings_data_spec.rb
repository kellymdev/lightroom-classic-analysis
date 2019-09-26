# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculateRatingsData, type: :service do
  describe '#call' do
    let(:image_1) { create(:image, rating: nil) }
    let(:image_2) { create(:image, rating: 3.0) }
    let(:image_3) { create(:image, rating: 4.0) }

    subject(:service) { CalculateRatingsData.new }

    before do
      image_1
      image_2
      image_3
    end

    context 'unrated' do
      before do
        image_3.update!(rating: nil)
      end

      context 'count' do
        it 'is the total number of unrated images' do
          expect(service.call[:unrated_count]).to eq 2
        end
      end

      context 'percentage' do
        it 'is the percentage of unrated images' do
          expect(service.call[:unrated_percentage]).to eq 66.67
        end
      end
    end

    context 'one star' do
      before do
        image_1.update!(rating: 1.0)
        image_2. update!(rating: 1.0)
      end

      context 'count' do
        it 'is the total number of images with 1 star' do
          expect(service.call[:one_star_count]).to eq 2
        end
      end

      context 'percentage' do
        it 'is the percentage of images with 1 star' do
          expect(service.call[:one_star_percentage]).to eq 66.67
        end
      end
    end

    context 'two stars' do
      before do
        image_1.update!(rating: 2.0)
        image_2.update!(rating: 2.0)
      end

      context 'count' do
        it 'is the total number of images with 2 stars' do
          expect(service.call[:two_star_count]).to eq 2
        end
      end

      context 'percentage' do
        it 'is the percentage of images with 2 stars' do
          expect(service.call[:two_star_percentage]).to eq 66.67
        end
      end
    end

    context 'three stars' do
      before do
        image_1.update!(rating: 3.0)
      end

      context 'count' do
        it 'is the total number of images with 3 stars' do
          expect(service.call[:three_star_count]).to eq 2
        end
      end

      context 'percentage' do
        it 'is the percentage of images with 3 stars' do
          expect(service.call[:three_star_percentage]).to eq 66.67
        end
      end
    end

    context 'four stars' do
      before do
        image_1.update!(rating: 4.0)
      end

      context 'count' do
        it 'is the total number of images with 4 stars' do
          expect(service.call[:four_star_count]).to eq 2
        end
      end

      context 'percentage' do
        it 'is the percentage of images with 4 stars' do
          expect(service.call[:four_star_percentage]).to eq 66.67
        end
      end
    end

    context 'five stars' do
      before do
        image_1.update!(rating: 5.0)
        image_2.update!(rating: 5.0)
      end

      context 'count' do
        it 'is the total number of images with 5 stars' do
          expect(service.call[:five_star_count]).to eq 2
        end
      end

      context 'percentage' do
        it 'is the percentage of images with 5 stars' do
          expect(service.call[:five_star_percentage]).to eq 66.67
        end
      end
    end
  end
end
