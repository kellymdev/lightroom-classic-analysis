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
          expect(service.call[:keywords]).to eq %w[kitten cat portrait]
        end
      end

      context 'cameras' do
        it 'lists the most frequently used camera models for that lens' do
          expect(service.call[:cameras]).to eq [camera_2.value, camera_1.value]
        end
      end

      context 'focal_lengths' do
        before do
          exif_1.update!(focalLength: 35.0)
          exif_2.update!(focalLength: 100.0)
          exif_3.update!(focalLength: 35.0)
        end

        it 'lists the most frequently used focal lengths for that lens' do
          expect(service.call[:focal_lengths]).to eq [35, 100]
        end
      end

      context 'shutter_speeds' do
        before do
          exif_1.update!(shutterSpeed: 5.91)
          exif_2.update!(shutterSpeed: 10.643856)
          exif_3.update!(shutterSpeed: 5.91)
        end

        it 'lists the most frequently used shutter speeds for that lens' do
          expect(service.call[:shutter_speeds]).to eq [60, 1600]
        end
      end

      context 'isos' do
        before do
          exif_1.update!(isoSpeedRating: 1600.0)
          exif_2.update!(isoSpeedRating: 100.0)
          exif_3.update!(isoSpeedRating: 100.0)
        end

        it 'lists the most frequently used isos for that lens' do
          expect(service.call[:isos]).to eq [100, 1600]
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
        before do
          exif_1.update!(dateMonth: 5.0)
          exif_2.update!(dateMonth: 8.0)
          exif_3.update!(dateMonth: 8.0)
        end

        it 'lists the most frequent months for that lens' do
          expect(service.call[:months]).to eq %w[August May]
        end
      end

      context 'years' do
        before do
          exif_1.update!(dateYear: 2018.0)
          exif_2.update!(dateYear: 2018.0)
          exif_3.update!(dateYear: 2017.0)
        end

        it 'lists the most frequent years for that lens' do
          expect(service.call[:years]).to eq [2018, 2017]
        end
      end

      context 'month year combinations' do
        before do
          exif_1.update!(dateMonth: 5.0, dateYear: 2017.0)
          exif_2.update!(dateMonth: 6.0, dateYear: 2018.0)
          exif_3.update!(dateMonth: 5.0, dateYear: 2017.0)
        end

        it 'lists the most frequent month year combinations for that lens' do
          expect(service.call[:month_year_combinations]).to eq ['May 2017', 'June 2018']
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

        it 'lists the most frequently used keywords for that lens and year' do
          expect(service.call[:keywords]).to eq %w[kitten cat portrait]
        end
      end

      context 'cameras' do
        it 'lists the most frequently used camera models for that lens and year' do
          expect(service.call[:cameras]).to eq ['Canon EOS 6D', 'Canon EOS 5D Mark IV']
        end
      end

      context 'focal_lengths' do
        before do
          exif_1.update!(focalLength: 24.0)
          exif_2.update!(focalLength: 50.0)
        end

        it 'lists the most frequently used focal lengths for that lens and year' do
          expect(service.call[:focal_lengths]).to eq [24, 50]
        end
      end

      context 'shutter_speeds' do
        before do
          exif_1.update!(shutterSpeed: 10.643856)
          exif_2.update!(shutterSpeed: 5.91)
        end

        it 'lists the most frequently used shutter speeds for that lens and year' do
          expect(service.call[:shutter_speeds]).to eq [1600, 60]
        end
      end

      context 'isos' do
        before do
          exif_1.update!(isoSpeedRating: 200.0)
          exif_2.update!(isoSpeedRating: 1250.0)
        end

        it 'lists the most frequently used isos for that lens and year' do
          expect(service.call[:isos]).to eq [200, 1250]
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
        before do
          exif_1.update!(dateMonth: 7.0)
          exif_2.update!(dateMonth: 1.0)
        end

        it 'lists the most frequent months for that lens and year' do
          expect(service.call[:months]).to eq %w[July January]
        end
      end

      context 'years' do
        it 'only returns the specified year' do
          expect(service.call[:years]).to eq [2018]
        end
      end

      context 'month_year_combinations' do
        before do
          exif_1.update!(dateMonth: 10.0)
          exif_2.update!(dateMonth: 3.0)
        end

        it 'only returns data for the specified year' do
          expect(service.call[:month_year_combinations]).to eq ['October 2018', 'March 2018']
        end
      end
    end
  end
end
