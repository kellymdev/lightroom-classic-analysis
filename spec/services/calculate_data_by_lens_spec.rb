# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculateDataByLens, type: :service do
  describe '#call' do
    let(:lens) { create(:lens) }

    let(:camera_1) { create(:camera, value: 'Canon EOS 6D') }
    let(:camera_2) { create(:camera, value: 'Canon EOS 5D Mark IV') }

    let(:exif_1) { create(:exif, lensRef: lens.id, cameraModelRef: camera_1.id) }
    let(:exif_2) { create(:exif, lensRef: lens.id, cameraModelRef: camera_2.id) }
    let(:exif_3) { create(:exif, lensRef: lens.id, cameraModelRef: camera_2.id) }

    before do
      exif_1
      exif_2
      exif_3
    end

    let(:year) {}

    subject(:service) { described_class.new('EF24-105mm f/4L IS USM', year) }

    context 'lens_name' do
      it 'is the name of the lens passed in' do
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
          exif_3.update!(dateYear: 2017.0)
        end

        it 'is the number of images for that lens for all years' do
          expect(service.call[:image_count]).to eq 3
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
          exif_1.update!(image: image_1.id)
          exif_2.update!(image: image_2.id)

          keyword_image_1
          keyword_image_2
          keyword_image_3
          keyword_image_4
        end

        it 'lists the most frequently used keywords for that lens' do
          expect(service.call[:keywords]).to eq expected_data
        end
      end

      context 'cameras' do
        let(:expected_data) do
          [
            {
              value: camera_2.value,
              percentage: 66.67
            },
            {
              value: camera_1.value,
              percentage: 33.33
            }
          ]
        end

        it 'lists the most frequently used camera models for that lens' do
          expect(service.call[:cameras]).to eq expected_data
        end
      end

      context 'focal_lengths' do
        let(:expected_data) do
          [
            {
              value: 35,
              percentage: 66.67
            },
            {
              value: 100,
              percentage: 33.33
            }
          ]
        end

        before do
          exif_1.update!(focalLength: 35.0)
          exif_2.update!(focalLength: 100.0)
          exif_3.update!(focalLength: 35.0)
        end

        it 'lists the most frequently used focal lengths for that lens' do
          expect(service.call[:focal_lengths]).to eq expected_data
        end
      end

      context 'shutter_speeds' do
        let(:expected_data) do
          [
            {
              value: (1 / 60r),
              percentage: 66.67
            },
            {
              value: (1 / 1600r),
              percentage: 33.33
            }
          ]
        end

        before do
          exif_1.update!(shutterSpeed: 5.91)
          exif_2.update!(shutterSpeed: 10.643856)
          exif_3.update!(shutterSpeed: 5.91)
        end

        it 'lists the most frequently used shutter speeds for that lens' do
          expect(service.call[:shutter_speeds]).to eq expected_data
        end
      end

      context 'isos' do
        let(:expected_data) do
          [
            {
              value: 100,
              percentage: 66.67
            },
            {
              value: 1600,
              percentage: 33.33
            }
          ]
        end

        before do
          exif_1.update!(isoSpeedRating: 1600.0)
          exif_2.update!(isoSpeedRating: 100.0)
          exif_3.update!(isoSpeedRating: 100.0)
        end

        it 'lists the most frequently used isos for that lens' do
          expect(service.call[:isos]).to eq expected_data
        end
      end

      context 'ratings' do
        let(:image_1) { create(:image, rating: 5.0) }
        let(:image_2) { create(:image, rating: 3.0) }
        let(:image_3) { create(:image, rating: 3.0) }

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
              count: 2,
              percentage: 66.67
            },
            four_stars: {
              rating: '4 stars',
              count: 0,
              percentage: 0.0
            },
            five_stars: {
              rating: '5 stars',
              count: 1,
              percentage: 33.33
            }
          }
        end

        before do
          image_1
          image_2
          image_3
          exif_1.update!(image: image_1.id)
          exif_2.update!(image: image_2.id)
          exif_3.update!(image: image_3.id)
        end

        it 'returns the number of images with each rating' do
          expect(service.call[:ratings]).to eq expected_data
        end
      end

      context 'months' do
        let(:expected_data) do
          [
            {
              value: 'August',
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
          exif_2.update!(dateMonth: 8.0)
          exif_3.update!(dateMonth: 8.0)
        end

        it 'lists the most frequent months for that lens' do
          expect(service.call[:months]).to eq expected_data
        end
      end

      context 'years' do
        let(:expected_data) do
          [
            {
              value: 2018,
              percentage: 66.67
            },
            {
              value: 2017,
              percentage: 33.33
            }
          ]
        end

        before do
          exif_1.update!(dateYear: 2018.0)
          exif_2.update!(dateYear: 2018.0)
          exif_3.update!(dateYear: 2017.0)
        end

        it 'lists the most frequent years for that lens' do
          expect(service.call[:years]).to eq expected_data
        end
      end

      context 'month year combinations' do
        let(:expected_data) do
          [
            {
              value: 'May 2017',
              percentage: 66.67
            },
            {
              value: 'June 2018',
              percentage: 33.33
            }
          ]
        end

        before do
          exif_1.update!(dateMonth: 5.0, dateYear: 2017.0)
          exif_2.update!(dateMonth: 6.0, dateYear: 2018.0)
          exif_3.update!(dateMonth: 5.0, dateYear: 2017.0)
        end

        it 'lists the most frequent month year combinations for that lens' do
          expect(service.call[:month_year_combinations]).to eq expected_data
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
        it 'is the year passed in' do
          expect(service.call[:years_covered]).to eq '2018'
        end
      end

      context 'image_count' do
        it 'is the number of images taken for that lens in that year' do
          expect(service.call[:image_count]).to eq 2
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
          exif_1.update!(image: image_1.id)
          exif_2.update!(image: image_2.id)

          keyword_image_1
          keyword_image_2
          keyword_image_3
          keyword_image_4
        end

        it 'lists the most frequently used keywords for that lens and year' do
          expect(service.call[:keywords]).to eq expected_data
        end
      end

      context 'cameras' do
        let(:expected_data) do
          [
            {
              value: 'Canon EOS 6D',
              percentage: 50
            },
            {
              value: 'Canon EOS 5D Mark IV',
              percentage: 50
            }
          ]
        end

        it 'lists the most frequently used camera models for that lens and year' do
          expect(service.call[:cameras]).to eq expected_data
        end
      end

      context 'focal_lengths' do
        let(:expected_data) do
          [
            {
              value: 24,
              percentage: 50
            },
            {
              value: 50,
              percentage: 50
            }
          ]
        end

        before do
          exif_1.update!(focalLength: 24.0)
          exif_2.update!(focalLength: 50.0)
        end

        it 'lists the most frequently used focal lengths for that lens and year' do
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
              value: (1 / 60r),
              percentage: 50
            }
          ]
        end

        before do
          exif_1.update!(shutterSpeed: 10.643856)
          exif_2.update!(shutterSpeed: 5.91)
        end

        it 'lists the most frequently used shutter speeds for that lens and year' do
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
              value: 1250,
              percentage: 50
            }
          ]
        end

        before do
          exif_1.update!(isoSpeedRating: 200.0)
          exif_2.update!(isoSpeedRating: 1250.0)
        end

        it 'lists the most frequently used isos for that lens and year' do
          expect(service.call[:isos]).to eq expected_data
        end
      end

      context 'ratings' do
        let(:image_1) { create(:image, rating: 5.0) }
        let(:image_2) { create(:image, rating: 3.0) }
        let(:image_3) { create(:image, rating: 3.0) } # for a different year

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
          image_1
          image_2
          image_3
          exif_1.update!(image: image_1.id)
          exif_2.update!(image: image_2.id)
          exif_3.update!(image: image_3.id)
        end

        it 'returns the number of images with each rating' do
          expect(service.call[:ratings]).to eq expected_data
        end
      end

      context 'months' do
        let(:expected_data) do
          [
            {
              value: 'July',
              percentage: 50
            },
            {
              value: 'January',
              percentage: 50
            }
          ]
        end

        before do
          exif_1.update!(dateMonth: 7.0)
          exif_2.update!(dateMonth: 1.0)
        end

        it 'lists the most frequent months for that lens and year' do
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
              value: 'October 2018',
              percentage: 50
            },
            {
              value: 'March 2018',
              percentage: 50
            }
          ]
        end

        before do
          exif_1.update!(dateMonth: 10.0)
          exif_2.update!(dateMonth: 3.0)
        end

        it 'only returns data for the specified year' do
          expect(service.call[:month_year_combinations]).to eq expected_data
        end
      end
    end
  end
end
