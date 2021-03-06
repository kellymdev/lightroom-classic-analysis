# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lens, type: :model do
  describe 'scopes' do
    let(:lens_1) { create(:lens, value: 'EF24-105mm f/4L IS USM') }
    let(:lens_2) { create(:lens, value: 'EF400mm f/5.6L USM') }
    let(:lens_3) { create(:lens, value: 'EF24-105mm f/4L IS USM') }

    before do
      lens_1
      lens_2
      lens_3
    end

    describe 'for_model_name' do
      it 'includes all lenses for that model name' do
        result = Lens.for_model_name('EF24-105mm f/4L IS USM')

        expect(result).to include lens_1
        expect(result).to include lens_3
      end

      it 'does not include other lenses' do
        expect(Lens.for_model_name('EF24-105mm f/4L IS USM')).not_to include lens_2
      end
    end

    describe 'macro' do
      before do
        lens_1.update!(value: 'EF100mm f/2.8 Macro USM')
        lens_2.update!(value: 'EF-S60mm f/2.8 Macro USM')
      end

      it 'includes all macro lenses' do
        result = Lens.macro

        expect(result).to include lens_1
        expect(result).to include lens_2
      end

      it 'does not include non-macro lenses' do
        expect(Lens.macro).not_to include lens_3
      end
    end
  end
end
