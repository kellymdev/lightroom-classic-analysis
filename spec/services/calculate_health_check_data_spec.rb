# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculateHealthCheckData, type: :service do
  describe '#call' do
    let(:image_1) { create(:image) }
    let(:image_2) { create(:image) }

    let(:keyword_1) { create(:keyword, lc_name: 'cat') }

    let(:keyword_image_1) { create(:keyword_image, image: image_1.id, tag: keyword_1.id) }

    subject(:service) { described_class.new }

    context 'images without keywords' do
      before do
        image_1
        image_2
        keyword_image_1
      end

      context 'count' do
        it 'returns the number of images without keywords' do
          expect(service.call[:images_without_keywords][:count]).to eq 1
        end
      end

      context 'percentage' do
        it 'returns the percentage of images without keywords' do
          expect(service.call[:images_without_keywords][:percentage]).to eq 50.0
        end
      end
    end
  end
end
