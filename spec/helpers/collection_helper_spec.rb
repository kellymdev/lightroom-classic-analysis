# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CollectionHelper, type: :helper do
  describe '.collection_overview_text' do
    context 'when there is a single collection' do
      it 'is the singular version of the text' do
        expect(helper.collection_overview_text(1)).to eq 'There is 1 collection'
      end
    end

    context 'when there is more than one collection' do
      it 'is the plural version of the text' do
        expect(helper.collection_overview_text(2)).to eq 'There are 2 collections'
      end
    end

    context 'when there are no collections' do
      it 'is the plural version of the text' do
        expect(helper.collection_overview_text(0)).to eq 'There are 0 collections'
      end
    end
  end
end
