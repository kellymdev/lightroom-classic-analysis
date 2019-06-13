require 'rails_helper'

RSpec.describe Exif, type: :model do
  before do
    exif
  end

  describe 'scopes' do
    describe 'wildlife' do
      let(:exif) { create(:exif, focalLength: focal_length) }

      context 'when the lens focal length is greater than 300' do
        let(:focal_length) { 400.0 }

        it 'is included in the results' do
          expect(Exif.wildlife).to include exif
        end
      end

      context 'when the lens focal length is 300' do
        let(:focal_length) { 300.0 }

        it 'is included in the results' do
          expect(Exif.wildlife).to include exif
        end
      end

      context 'when the lens focal length is less than 300' do
        let(:focal_length) { 100.0 }

        it 'is not included in the results' do
          expect(Exif.wildlife).not_to include exif
        end
      end
    end
  end

  describe '#shutter_speed_value' do
    let(:exif) { create(:exif, shutterSpeed: shutter_speed) }

    context 'when shutterSpeed is present' do
      let(:shutter_speed) { 10.643856 }

      it 'calculates the fractional shutter speed' do
        expect(exif.shutter_speed_value).to eq 1600
      end
    end

    context 'when shutterSpeed is not present' do
      let(:shutter_speed) {}

      it 'returns nil' do
        expect(exif.shutter_speed_value).to eq nil
      end
    end
  end

  describe '#month_and_year' do
    let(:month) {}
    let(:year) {}
    let(:exif) { create(:exif, dateMonth: month, dateYear: year) }

    context 'when dateMonth and dateYear are present' do
      let(:month) { 4.0 }
      let(:year) { 2019.0 }

      it 'calculates the month and year' do
        expect(exif.month_and_year).to eq 'April 2019'
      end
    end

    context 'when only dateMonth is present' do
      let(:month) { 5.0 }

      it 'returns nil' do
        expect(exif.month_and_year).to eq nil
      end
    end

    context 'when only dateYear is present' do
      let(:year) { 2018.0 }

      it 'returns nil' do
        expect(exif.month_and_year).to eq nil
      end
    end

    context 'when neither dateMonth or dateYear are present' do
      it 'returns nil' do
        expect(exif.month_and_year).to eq nil
      end
    end
  end
end
