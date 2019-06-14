require 'rails_helper'

RSpec.describe LensHelper, type: :helper do
  describe 'lenses_for_select' do
    let(:lens_1) { create(:lens, value: 'EF24-105mm f/4L IS USM') }
    let(:lens_2) { create(:lens, value: 'EF400mm f/5.6L USM') }

    before do
      lens_1
      lens_2
    end

    it 'returns a list of lenses' do
      expect(helper.lenses_for_select).to eq [['EF24-105mm f/4L IS USM', 'EF24-105mm f/4L IS USM'],['EF400mm f/5.6L USM', 'EF400mm f/5.6L USM']]
    end

    context 'when there is more than one lens with the same value' do
      let(:lens_3) { create(:lens, value: 'EF24-105mm f/4L IS USM') }

      before do
        lens_3
      end

      it 'only returns one record for the lens name' do
        expect(helper.lenses_for_select).to eq [['EF24-105mm f/4L IS USM', 'EF24-105mm f/4L IS USM'],['EF400mm f/5.6L USM', 'EF400mm f/5.6L USM']]
      end
    end
  end
end
