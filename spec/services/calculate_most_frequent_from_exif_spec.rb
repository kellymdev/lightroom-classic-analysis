# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculateMostFrequentFromExif, type: :service do
  describe '#call' do
    let(:camera_1) { create(:camera, value: 'Canon EOS 6D') }
    let(:camera_2) { create(:camera, value: 'Canon EOS 5D Mark IV') }
    let(:lens_1) { create(:lens, value: 'EF24-105mm f/4L IS USM') }
    let(:lens_2) { create(:lens, value: 'EF16-35mm f/4L IS USM') }
    let(:iso) { 100.0 }

    let(:exif_1) { create(:exif, focalLength: 35.0, isoSpeedRating: iso, cameraModelRef: camera_1.id, lensRef: lens_1.id) }
    let(:exif_2) { create(:exif, focalLength: 24.0, isoSpeedRating: iso, cameraModelRef: camera_2.id, lensRef: lens_1.id) }
    let(:exif_3) { create(:exif, focalLength: 16.0, isoSpeedRating: iso, cameraModelRef: camera_2.id, lensRef: lens_2.id) }

    let(:exif_scope) { Exif.wide_angle_landscape }
    let(:number_of_results) { 2 }

    subject(:service) { described_class.new(exif_scope, number_of_results) }

    before do
      exif_1
      exif_2
      exif_3
    end

    context 'cameras' do
      let(:expected_data) do
        [
          {
            value: 'Canon EOS 5D Mark IV',
            percentage: 66.67
          },
          {
            value: 'Canon EOS 6D',
            percentage: 33.33
          }
        ]
      end

      it 'is the most frequently used cameras for the scope' do
        expect(service.call[:cameras]).to eq expected_data
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
            value: 'EF16-35mm f/4L IS USM',
            percentage: 33.33
          }
        ]
      end

      it 'is the most frequently used lenses for the scope' do
        expect(service.call[:lenses]).to eq expected_data
      end
    end

    context 'camera_lens_combinations' do
      let(:expected_data) do
        [
          {
            value: 'Canon EOS 6D - EF24-105mm f/4L IS USM',
            percentage: 33.33
          },
          {
            value: 'Canon EOS 5D Mark IV - EF24-105mm f/4L IS USM',
            percentage: 33.33
          }
        ]
      end

      it 'is the most frequently used camera and lens combinations for the scope' do
        expect(service.call[:camera_lens_combinations]).to eq expected_data
      end
    end

    context 'focal_lengths' do
      let(:expected_data) do
        [
          {
            value: 24,
            percentage: 66.67
          },
          {
            value: 35,
            percentage: 33.33
          }
        ]
      end

      before do
        exif_3.update!(focalLength: 24.0)
      end

      it 'is the most frequently used focal lengths for the scope' do
        expect(service.call[:focal_lengths]).to eq expected_data
      end
    end

    context 'isos' do
      let(:exif_scope) { Exif.all }

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
        exif_1.update!(isoSpeedRating: 1600.0)
        exif_3.update!(isoSpeedRating: 1600.0)
      end

      it 'is the most frequently used isos for the scope' do
        expect(service.call[:isos]).to eq expected_data
      end
    end

    context 'shutter_speeds' do
      let(:shutter_speed_1) { 5.91 }
      let(:shutter_speed_2) { 7.96 }

      let(:expected_data) do
        [
          {
            value: (1 / 60r),
            percentage: 66.67
          },
          {
            value: (1 / 249r),
            percentage: 33.33
          }
        ]
      end

      before do
        exif_1.update!(shutterSpeed: shutter_speed_1)
        exif_2.update!(shutterSpeed: shutter_speed_2)
        exif_3.update!(shutterSpeed: shutter_speed_1)
      end

      it 'is the most frequently used shutter speeds for the scope' do
        expect(service.call[:shutter_speeds]).to eq expected_data
      end
    end

    context 'ratings' do
      let(:image_1) { create(:image, rating: 5.0) }
      let(:image_2) { create(:image, rating: 4.0) }
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
            value: 'April',
            percentage: 66.67
          },
          {
            value: 'November',
            percentage: 33.33
          }
        ]
      end

      before do
        exif_1.update!(dateMonth: 4.0)
        exif_2.update!(dateMonth: 4.0)
        exif_3.update!(dateMonth: 11.0)
      end

      it 'is the most frequent months for the scope' do
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
            value: 2019,
            percentage: 33.33
          }
        ]
      end

      before do
        exif_1.update!(dateYear: 2019.0)
        exif_2.update!(dateYear: 2018.0)
        exif_3.update!(dateYear: 2018.0)
      end

      it 'is the most frequent years for the scope' do
        expect(service.call[:years]).to eq expected_data
      end
    end

    context 'month_year_combinations' do
      let(:expected_data) do
        [
          {
            value: 'June 2019',
            percentage: 66.67
          },
          {
            value: 'August 2018',
            percentage: 33.33
          }
        ]
      end

      before do
        exif_1.update!(dateMonth: 6.0, dateYear: 2019.0)
        exif_2.update!(dateMonth: 8.0, dateYear: 2018.0)
        exif_3.update!(dateMonth: 6.0, dateYear: 2019.0)
      end

      it 'is the most frequent month year combinations for the scope' do
        expect(service.call[:month_year_combinations]).to eq expected_data
      end
    end
  end
end
