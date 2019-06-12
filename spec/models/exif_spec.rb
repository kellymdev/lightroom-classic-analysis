require 'rails_helper'

RSpec.describe Exif, type: :model do
  describe 'scopes' do
    describe 'wildlife' do
      let(:exif) { create(:exif, focalLength: focal_length) }

      before do
        exif
      end

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
end
