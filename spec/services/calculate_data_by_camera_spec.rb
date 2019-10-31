# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculateDataByCamera, type: :service do
  describe '#call' do
    let(:camera) { create(:camera) }
    let(:lens_1) { create(:lens, value: 'EF24-105mm f/4L IS USM') }
    let(:lens_2) { create(:lens, value: 'EF400mm f/5.6L USM') }

    let(:image_1) { create(:image) }
    let(:image_2) { create(:image) }

    let(:exif_1) { create(:exif, cameraModelRef: camera.id, lensRef: lens_1.id, image: image_1.id) }
    let(:exif_2) { create(:exif, cameraModelRef: camera.id, lensRef: lens_2.id, image: image_2.id) }
    let(:exif_3) { create(:exif, cameraModelRef: camera.id, lensRef: lens_1.id) }

    before do
      exif_1
      exif_2
      exif_3
    end

    let(:year) { nil }

    subject(:service) { CalculateDataByCamera.new('Canon EOS 5D Mark IV', year) }

    context 'camera' do
      it 'returns the camera name passed in' do
        expect(service.call[:camera]).to eq 'Canon EOS 5D Mark IV'
      end
    end

    context 'when no year is passed in' do
      context 'years_covered' do
        it 'returns All years' do
          expect(service.call[:years_covered]).to eq 'All years'
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

        it 'returns the most frequently used keywords for that camera' do
          expect(service.call[:keywords]).to eq expected_data
        end
      end

      context 'lenses' do
        let(:expected_data) do
          [
            {
              value: 'EF24-105mm f/4L IS USM',
              percentage: 66.67
            },
            {
              value: 'EF400mm f/5.6L USM',
              percentage: 33.33
            }
          ]
        end

        it 'returns the most frequently used lenses for that camera' do
          expect(service.call[:lenses]).to eq expected_data
        end
      end

      context 'focal_lengths' do
        let(:expected_data) do
          [
            {
              value: 100,
              percentage: 66.67
            },
            {
              value: 200,
              percentage: 33.33
            }
          ]
        end

        before do
          exif_1.update!(focalLength: 200.0)
        end

        it 'returns the most frequently used focal lengths for that camera' do
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

        it 'returns the most frequently used shutter speeds for that camera' do
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
              value: 1000,
              percentage: 33.33
            }
          ]
        end

        before do
          exif_1.update!(isoSpeedRating: 1000)
        end

        it 'returns the most frequently used isos for that camera' do
          expect(service.call[:isos]).to eq expected_data
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
              value: 'May',
              percentage: 33.33
            }
          ]
        end

        before do
          exif_1.update!(dateMonth: 5.0)
        end

        it 'returns the most frequent months for that camera' do
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
              value: 2017,
              percentage: 33.33
            }
          ]
        end

        before do
          exif_1.update!(dateYear: 2017.0)
        end

        it 'returns the most frequent years for that camera' do
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
              value: 'April 2018',
              percentage: 33.33
            }
          ]
        end

        before do
          exif_1.update!(dateMonth: 4.0, dateYear: 2018.0)
        end

        it 'returns the most frequent month year combinations for that camera' do
          expect(service.call[:month_year_combinations]).to eq expected_data
        end
      end

      context 'ratings' do
        let(:image_3) { create(:image, rating: 4.0) }

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
              percentage: 33.33
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
          image_1.update!(rating: 5.0)
          image_2.update!(rating: 3.0)
          exif_3.update!(image: image_3.id)
        end

        it 'returns the number of images with each rating' do
          expect(service.call[:ratings]).to eq expected_data
        end
      end
    end

    context 'when a year is passed in' do
      let(:year) { '2018' }

      before do
        exif_1.update!(dateYear: 2018.0)
        exif_2.update!(dateYear: 2018.0)
      end

      context 'years_covered' do
        it 'returns the year passed in' do
          expect(service.call[:years_covered]).to eq '2018'
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

        it 'returns keywords for the selected camera and year' do
          expect(service.call[:keywords]).to eq expected_data
        end
      end

      context 'lenses' do
        let(:expected_data) do
          [
            {
              value: 'EF24-105mm f/4L IS USM',
              percentage: 50
            },
            {
              value: 'EF400mm f/5.6L USM',
              percentage: 50
            }
          ]
        end

        it 'returns the most frequently used lenses for that camera and year' do
          expect(service.call[:lenses]).to eq expected_data
        end
      end

      context 'focal_lengths' do
        let(:expected_data) do
          [
            {
              value: 35,
              percentage: 50
            },
            {
              value: 400,
              percentage: 50
            }
          ]
        end

        before do
          exif_1.update!(focalLength: 35.0)
          exif_2.update!(focalLength: 400.0)
        end

        it 'returns the most frequently used focal lengths for that camera and year' do
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
          exif_2.update!(shutterSpeed: 4.07)
        end

        it 'returns the most frequently used shutter speeds for that camera and year' do
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
              value: 1000,
              percentage: 50
            }
          ]
        end

        before do
          exif_1.update!(isoSpeedRating: 200.0)
          exif_2.update!(isoSpeedRating: 1000.0)
        end

        it 'returns the most frequently used isos for that camera and year' do
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
              count: 0,
              percentage: 0.0
            },
            five_stars: {
              rating: '5 stars',
              count: 1,
              percentage: 50.0
            }
          }
        end

        before do
          image_1.update!(rating: 3.0)
          image_2.update!(rating: 5.0)
        end

        it 'returns the number of images with each rating' do
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
              value: 'March',
              percentage: 50
            }
          ]
        end

        before do
          exif_1.update!(dateMonth: 9.0)
          exif_2.update!(dateMonth: 3.0)
        end

        it 'returns the most frequent months for that camera and lens' do
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

        it 'only returns data for the year passed in' do
          expect(service.call[:years]).to eq expected_data
        end
      end

      context 'month_year_combinations' do
        let(:expected_data) do
          [
            {
              value: 'November 2018',
              percentage: 50
            },
            {
              value: 'May 2018',
              percentage: 50
            }
          ]
        end

        before do
          exif_1.update!(dateMonth: 11.0)
          exif_2.update!(dateMonth: 5.0)
        end

        it 'only returns data for the year passed in' do
          expect(service.call[:month_year_combinations]).to eq expected_data
        end
      end
    end
  end
end
