# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection, type: :model do
  describe 'scopes' do
    describe 'viewable' do
      let(:collection) { create(:collection, systemOnly: system_only_flag) }

      before do
        collection
      end

      context 'when systemOnly is set to 0.0' do
        let(:system_only_flag) { 0.0 }

        it 'is included in the results' do
          expect(Collection.viewable).to include collection
        end
      end

      context 'when systemOnly is set to 1.0' do
        let(:system_only_flag) { 1.0 }

        it 'is not included in the results' do
          expect(Collection.viewable).not_to include collection
        end
      end
    end
  end
end
