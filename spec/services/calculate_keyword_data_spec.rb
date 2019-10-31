# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculateKeywordData, type: :service do
  describe '#call' do
    let(:keyword_1) { create(:keyword, lc_name: 'dog') }
    let(:keyword_2) { create(:keyword, lc_name: 'cat') }

    let(:image_1) { create(:image) }
    let(:image_2) { create(:image) }
    let(:image_3) { create(:image) }

    let(:keyword_image_1) { create(:keyword_image, image: image_1.id, tag: keyword_1.id) }
    let(:keyword_image_2) { create(:keyword_image, image: image_2.id, tag: keyword_2.id) }
    let(:keyword_image_3) { create(:keyword_image, image: image_3.id, tag: keyword_2.id) }

    before do
      keyword_image_1
      keyword_image_2
      keyword_image_3
    end

    subject(:service) { CalculateKeywordData.new }

    context 'most frequent keywords' do
      let(:expected_data) do
        [
          {
            value: 'cat',
            percentage: 66.67
          },
          {
            value: 'dog',
            percentage: 33.33
          }
        ]
      end

      it 'returns an array of the most frequently used keyword values' do
        expect(service.call[:most_frequent_keywords]).to eq expected_data
      end
    end

    context 'most frequent wildlife keywords' do
      let(:keyword_3) { create(:keyword, lc_name: 'seal') }
      let(:image_4) { create(:image) }
      let(:keyword_image_4) { create(:keyword_image, image: image_4.id, tag: keyword_3.id) }

      let(:exif_1) { create(:exif, image: image_1.id, focalLength: 400.0) }
      let(:exif_2) { create(:exif, image: image_2.id) }
      let(:exif_3) { create(:exif, image: image_3.id) }
      let(:exif_4) { create(:exif, image: image_4.id, focalLength: 350.0) }

      let(:expected_data) do
        [
          {
            value: 'dog',
            percentage: 50
          },
          {
            value: 'seal',
            percentage: 50
          }
        ]
      end

      before do
        keyword_image_4

        exif_1
        exif_2
        exif_3
        exif_4
      end

      it 'returns an array of the most frequently used keyword values for wildlife' do
        expect(service.call[:most_frequent_wildlife_keywords]).to eq expected_data
      end
    end

    context 'most frequent landscape keywords' do
      let(:iso) { 100.0 }
      let(:camera) { create(:camera, value: 'Canon EOS 6D') }
      let(:keyword_3) { create(:keyword, lc_name: 'mountain') }
      let(:image_4) { create(:image) }
      let(:keyword_image_4) { create(:keyword_image, image: image_4.id, tag: keyword_3.id) }

      let(:exif_1) { create(:exif, image: image_1.id, focalLength: 35.0, isoSpeedRating: iso, cameraModelRef: camera.id) }
      let(:exif_2) { create(:exif, image: image_2.id, focalLength: 24.0, isoSpeedRating: iso, cameraModelRef: camera.id) }
      let(:exif_3) { create(:exif, image: image_3.id, focalLength: 400.0, isoSpeedRating: iso, cameraModelRef: camera.id) }
      let(:exif_4) { create(:exif, image: image_4.id, focalLength: 17.0, isoSpeedRating: iso, cameraModelRef: camera.id) }

      let(:expected_data) do
        [
          {
            value: 'dog',
            percentage: 33.33
          },
          {
            value: 'cat',
            percentage: 33.33
          },
          {
            value: 'mountain',
            percentage: 33.33
          }
        ]
      end

      before do
        keyword_image_4

        exif_1
        exif_2
        exif_3
        exif_4
      end

      it 'returns an array of the most frequently used keyword values for wide angle landscape' do
        expect(service.call[:most_frequent_landscape_keywords]).to eq expected_data
      end
    end

    context 'most frequent macro keywords' do
      let(:lens_1) { create(:lens, value: 'EF100mm f/2.8 Macro USM') }
      let(:lens_2) { create(:lens, value: 'EF24-105mm f/4L IS USM') }
      let(:keyword_3) { create(:keyword, lc_name: 'butterfly') }
      let(:image_4) { create(:image) }
      let(:keyword_image_4) { create(:keyword_image, image: image_4.id, tag: keyword_3.id) }

      let(:exif_1) { create(:exif, image: image_1.id, lensRef: lens_1.id) }
      let(:exif_2) { create(:exif, image: image_2.id, lensRef: lens_2.id) }
      let(:exif_3) { create(:exif, image: image_3.id, lensRef: lens_2.id) }
      let(:exif_4) { create(:exif, image: image_4.id, lensRef: lens_1.id) }

      let(:expected_data) do
        [
          {
            value: 'dog',
            percentage: 50
          },
          {
            value: 'butterfly',
            percentage: 50
          }
        ]
      end

      before do
        keyword_image_4

        exif_1
        exif_2
        exif_3
        exif_4
      end

      it 'returns an array of the most frequently used keyword values for macro' do
        expect(service.call[:most_frequent_macro_keywords]).to eq expected_data
      end
    end

    context 'most frequent astro keywords' do
      let(:keyword_3) { create(:keyword, lc_name: 'stars') }
      let(:image_4) { create(:image) }
      let(:keyword_image_4) { create(:keyword_image, image: image_4.id, tag: keyword_3.id) }
      let(:keyword_image_5) { create(:keyword_image, image: image_1.id, tag: keyword_3.id) }
      let(:keyword_image_6) { create(:keyword_image, image: image_2.id, tag: keyword_3.id) }

      let(:exif_1) { create(:exif, image: image_1.id, isoSpeedRating: 3200.0, aperture: 4.0) }
      let(:exif_2) { create(:exif, image: image_2.id, isoSpeedRating: 4000.0, aperture: 4.0) }
      let(:exif_3) { create(:exif, image: image_3.id, isoSpeedRating: 3200.0, aperture: 2.8) }
      let(:exif_4) { create(:exif, image: image_4.id, isoSpeedRating: 3200.0, aperture: 4.0) }

      let(:expected_data) do
        [
          {
            value: 'stars',
            percentage: 50
          },
          {
            value: 'cat',
            percentage: 33.33
          },
          {
            value: 'dog',
            percentage: 16.67
          }
        ]
      end

      before do
        keyword_image_4
        keyword_image_5
        keyword_image_6

        exif_1
        exif_2
        exif_3
        exif_4
      end

      it 'returns the most frequently used keyword values for astro' do
        expect(service.call[:most_frequent_astro_keywords]).to eq expected_data
      end
    end
  end
end
