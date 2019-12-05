# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculateDataByCameraAndLens, type: :service do
  describe '#call' do
    let(:camera) { create(:camera, value: camera_name) }
    let(:lens) { create(:lens, value: lens_name) }

    let(:image_1) { create(:image) }
    let(:image_2) { create(:image) }

    let(:exif_1) { create(:exif, cameraModelRef: camera.id, lensRef: lens.id, image: image_1.id) }
    let(:exif_2) { create(:exif, cameraModelRef: camera.id, lensRef: lens.id, image: image_2.id) }
    let(:exif_3) { create(:exif, cameraModelRef: camera.id, lensRef: lens.id) }

    let(:camera_name) { 'Canon EOS 5D Mark IV' }
    let(:lens_name) { 'EF24-105mm f/4L IS USM' }
    let(:year) {}

    subject(:service) { described_class.new(camera_name, lens_name, year) }

    before do
      exif_1
      exif_2
      exif_3
    end

    context 'camera' do
      it 'is the camera name that was passed in' do
        expect(service.call[:camera]).to eq 'Canon EOS 5D Mark IV'
      end
    end

    context 'lens' do
      it 'is the lens name that was passed in' do
        expect(service.call[:lens]).to eq 'EF24-105mm f/4L IS USM'
      end
    end

    context 'when a year is not passed in' do
      context 'years_covered' do
        it 'is All years' do
          expect(service.call[:years_covered]).to eq 'All years'
        end
      end

      context 'image_count' do
        before do
          exif_2.update!(dateYear: 2017.0)
        end

        it 'is the number of images taken with that camera and lens for all years' do
          expect(service.call[:image_count]).to eq 3
        end
      end

      context 'keywords' do
        let(:keyword_1) { create(:keyword, lc_name: 'cat') }
        let(:keyword_2) { create(:keyword, lc_name: 'kitten') }
        let(:keyword_3) { create(:keyword, lc_name: 'portrait') }

        let(:keyword_image_1) { create(:keyword_image, image: image_1.id, tag: keyword_1.id) }
        let(:keyword_image_2) { create(:keyword_image, image: image_1.id, tag: keyword_2.id) }
        let(:keyword_image_3) { create(:keyword_image, image: image_1.id, tag: keyword_3.id) }
        let(:keyword_image_4) { create(:keyword_image, image: image_2.id, tag: keyword_2.id) }

        let(:expected_data) do
          [
            {
              value: 'kitten',
              percentage: 50
            },
            {
              value: 'cat',
              percentage: 25
            },
            {
              value: 'portrait',
              percentage: 25
            }
          ]
        end

        before do
          keyword_image_1
          keyword_image_2
          keyword_image_3
          keyword_image_4
        end

        it 'returns the most frequently used keywords for that camera and lens' do
          expect(service.call[:keywords]).to eq expected_data
        end
      end

      context 'focal_lengths' do
        let(:expected_data) do
          [
            {
              value: 25,
              percentage: 66.67
            },
            {
              value: 45,
              percentage: 33.33
            }
          ]
        end

        before do
          exif_1.update!(focalLength: 25.0)
          exif_2.update!(focalLength: 45.0)
          exif_3.update!(focalLength: 25.0)
        end

        it 'returns the most frequently used focal lengths for that camera and lens' do
          expect(service.call[:focal_lengths]).to eq expected_data
        end
      end

      context 'shutter_speeds' do
        let(:expected_data) do
          [
            {
              value: (1 / 17r),
              percentage: 66.67
            },
            {
              value: (1 / 1600r),
              percentage: 33.33
            }
          ]
        end

        before do
          exif_1.update!(shutterSpeed: 10.643856)
        end

        it 'returns the most frequently used shutter speeds for that camera and lens' do
          expect(service.call[:shutter_speeds]).to eq expected_data
        end
      end

      context 'isos' do
        let(:expected_data) do
          [
            {
              value: 1600,
              percentage: 66.67
            },
            {
              value: 100,
              percentage: 33.33
            }
          ]
        end

        before do
          exif_1.update!(isoSpeedRating: 100.0)
        end

        it 'returns the most frequently used isos for that camera and lens' do
          expect(service.call[:isos]).to eq expected_data
        end
      end

      context 'ratings' do
        let(:image_3) { create(:image, rating: 5.0) }

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
              count: 1,
              percentage: 33.33
            },
            three_stars: {
              rating: '3 stars',
              count: 0,
              percentage: 0.0
            },
            four_stars: {
              rating: '4 stars',
              count: 1,
              percentage: 33.33
            },
            five_stars: {
              rating: '5 stars',
              count: 1,
              percentage: 33.33
            }
          }
        end

        before do
          image_3
          image_1.update!(rating: 4.0)
          image_2.update!(rating: 2.0)
          exif_3.update!(image: image_3.id)
        end

        it 'returns the number of images for each rating' do
          expect(service.call[:ratings]).to eq expected_data
        end
      end

      context 'months' do
        let(:expected_data) do
          [
            {
              value: 'February',
              percentage: 66.67
            },
            {
              value: 'July',
              percentage: 33.33
            }
          ]
        end

        before do
          exif_2.update!(dateMonth: 7.0)
        end

        it 'returns the most frequent months for that camera and lens' do
          expect(service.call[:months]).to eq expected_data
        end
      end

      context 'years' do
        let(:expected_data) do
          [
            {
              value: 2019,
              percentage: 66.67
            },
            {
              value: 2018,
              percentage: 33.33
            }
          ]
        end

        before do
          exif_1.update!(dateYear: 2018.0)
        end

        it 'returns the most frequent years for that camera and lens' do
          expect(service.call[:years]).to eq expected_data
        end
      end

      context 'month_year_combinations' do
        let(:expected_data) do
          [
            {
              value: 'February 2019',
              percentage: 66.67
            },
            {
              value: 'July 2018',
              percentage: 33.33
            }
          ]
        end

        before do
          exif_2.update!(dateMonth: 7.0, dateYear: 2018.0)
        end

        it 'returns the most frequent month year combinations for that lens' do
          expect(service.call[:month_year_combinations]).to eq expected_data
        end
      end
    end

    context 'when a year is passed in' do
      let(:year) { '2018' }

      before do
        exif_1.update!(dateYear: 2018.0)
        exif_2.update!(dateYear: 2018.0)
        exif_3.update!(dateYear: 2017.0)
      end

      context 'years_covered' do
        it 'is the year passed in' do
          expect(service.call[:years_covered]).to eq '2018'
        end
      end

      context 'image_count' do
        it 'is the number of images taken with that camera and lens for that year' do
          expect(service.call[:image_count]).to eq 2
        end
      end

      context 'keywords' do
        let(:keyword_1) { create(:keyword, lc_name: 'cat') }
        let(:keyword_2) { create(:keyword, lc_name: 'kitten') }
        let(:keyword_3) { create(:keyword, lc_name: 'portrait') }

        let(:keyword_image_1) { create(:keyword_image, image: image_1.id, tag: keyword_1.id) }
        let(:keyword_image_2) { create(:keyword_image, image: image_1.id, tag: keyword_2.id) }
        let(:keyword_image_3) { create(:keyword_image, image: image_1.id, tag: keyword_3.id) }
        let(:keyword_image_4) { create(:keyword_image, image: image_2.id, tag: keyword_2.id) }

        let(:expected_data) do
          [
            {
              value: 'kitten',
              percentage: 50
            },
            {
              value: 'cat',
              percentage: 25
            },
            {
              value: 'portrait',
              percentage: 25
            }
          ]
        end

        before do
          keyword_image_1
          keyword_image_2
          keyword_image_3
          keyword_image_4
        end

        it 'returns the most frequently used keywords for that camera, lens and year' do
          expect(service.call[:keywords]).to eq expected_data
        end
      end

      context 'focal_lengths' do
        let(:expected_data) do
          [
            {
              value: 200,
              percentage: 50
            },
            {
              value: 40,
              percentage: 50
            }
          ]
        end

        before do
          exif_1.update!(focalLength: 200.0)
          exif_2.update!(focalLength: 40.0)
        end

        it 'returns the most frequently used focal lengths for that camera, lens and year' do
          expect(service.call[:focal_lengths]).to eq expected_data
        end
      end

      context 'shutter_speeds' do
        let(:expected_data) do
          [
            {
              value: (1 / 1600r),
              percentage: 50
            },
            {
              value: (1 / 17r),
              percentage: 50
            }
          ]
        end

        before do
          exif_1.update!(shutterSpeed: 10.643856)
        end

        it 'returns the most frequently used shutter speeds for that camera, lens and year' do
          expect(service.call[:shutter_speeds]).to eq expected_data
        end
      end

      context 'isos' do
        let(:expected_data) do
          [
            {
              value: 200,
              percentage: 50
            },
            {
              value: 1600,
              percentage: 50
            }
          ]
        end

        before do
          exif_1.update!(isoSpeedRating: 200.0)
        end

        it 'returns the most frequently used isos for that camera, lens and year' do
          expect(service.call[:isos]).to eq expected_data
        end
      end

      context 'ratings' do
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
              count: 1,
              percentage: 50.0
            },
            four_stars: {
              rating: '4 stars',
              count: 1,
              percentage: 50.0
            },
            five_stars: {
              rating: '5 stars',
              count: 0,
              percentage: 0.0
            }
          }
        end

        before do
          image_1.update!(rating: 4.0)
          image_2.update!(rating: 3.0)
        end

        it 'returns the number of images for each rating' do
          expect(service.call[:ratings]).to eq expected_data
        end
      end

      context 'months' do
        let(:expected_data) do
          [
            {
              value: 'September',
              percentage: 50
            },
            {
              value: 'February',
              percentage: 50
            }
          ]
        end

        before do
          exif_1.update!(dateMonth: 9.0)
        end

        it 'returns the most frequent months for that camera, lens and year' do
          expect(service.call[:months]).to eq expected_data
        end
      end

      context 'years' do
        let(:expected_data) do
          [
            {
              value: 2018,
              percentage: 100
            }
          ]
        end

        it 'only returns the specified year' do
          expect(service.call[:years]).to eq expected_data
        end
      end

      context 'month_year_combinations' do
        let(:expected_data) do
          [
            {
              value: 'February 2018',
              percentage: 50
            },
            {
              value: 'November 2018',
              percentage: 50
            }
          ]
        end

        before do
          exif_2.update!(dateMonth: 11.0)
        end

        it 'returns the most frequent month year combinations for that camera, lens and year' do
          expect(service.call[:month_year_combinations]).to eq expected_data
        end
      end
    end
  end
end
