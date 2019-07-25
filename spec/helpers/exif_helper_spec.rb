require 'rails_helper'

RSpec.describe ExifHelper, type: :helper do
  describe '#years_for_select' do
    let(:exif_1) { create(:exif, dateYear: 2018.0) }
    let(:exif_2) { create(:exif, dateYear: 2017.0) }

    before do
      exif_1
      exif_2
    end

    it 'lists all the years from the exif data in descending order' do
      expect(helper.years_for_select).to eq [[2018, 2018], [2017, 2017]]
    end

    context 'when there is an exif record with a nil year' do
      let(:exif_3) { create(:exif, dateYear: nil) }

      before do
        exif_3
      end

      it 'lists the years that actually have a value' do
        expect(helper.years_for_select).to eq [[2018, 2018], [2017, 2017]]
      end
    end
  end
end
