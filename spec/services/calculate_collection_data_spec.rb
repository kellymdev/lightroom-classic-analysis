# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculateCollectionData, type: :service do
  describe '#call' do
    let(:collection_1) { create(:collection, name: 'Collection 1') }

    subject(:service) { described_class.new }

    before do
      collection_1
    end

    context 'collection_count' do
      let(:collection_2) { create(:collection, name: 'Collection 2') }
      let(:collection_3) { create(:collection, name: 'Collection 3', systemOnly: 1.0) }

      before do
        collection_2
        collection_3
      end

      it 'returns the number of viewable collections' do
        expect(service.call[:collection_count]).to eq 2
      end
    end

    context 'images_in_collections' do
      let(:image_1) { create(:image) }
      let(:image_2) { create(:image) }
      let(:image_3) { create(:image) }
      let(:collection_image_1) { create(:collection_image, collection: collection_1.id, image: image_1.id) }
      let(:collection_image_2) { create(:collection_image, collection: collection_1.id, image: image_3.id) }

      before do
        image_2
        collection_image_1
        collection_image_2
      end

      it 'returns the number of images in collections' do
        expect(service.call[:images_in_collections]).to eq 2
      end
    end

    context 'collection_data' do
      context 'when there are no images in a collection' do
        let(:expected_data) do
          [
            {
              name: 'Collection 1',
              image_count: 0,
              sub_collection_count: 0,
              sub_collections: []
            }
          ]
        end

        it 'returns an image count of 0' do
          expect(service.call[:collection_data]).to eq expected_data
        end
      end

      context 'when the collection contains images' do
        let(:image_1) { create(:image) }
        let(:image_2) { create(:image) }
        let(:collection_image_1) { create(:collection_image, collection: collection_1.id, image: image_1.id) }
        let(:collection_image_2) { create(:collection_image, collection: collection_1.id) }

        let(:expected_data) do
          [
            {
              name: 'Collection 1',
              image_count: 2,
              sub_collection_count: 0,
              sub_collections: []
            }
          ]
        end

        before do
          collection_image_1
          collection_image_2
        end

        it 'returns the number of images in the collection' do
          expect(service.call[:collection_data]).to eq expected_data
        end
      end

      context 'when there is more than one collection' do
        let(:collection_2) { create(:collection, name: 'Collection 2') }
        let(:image_1) { create(:image) }
        let(:image_2) { create(:image) }
        let(:image_3) { create(:image) }
        let(:collection_image_1) { create(:collection_image, collection: collection_1.id, image: image_1.id) }
        let(:collection_image_2) { create(:collection_image, collection: collection_2.id, image: image_2.id) }
        let(:collection_image_3) { create(:collection_image, collection: collection_1.id, image: image_3.id) }

        let(:expected_data) do
          [
            {
              name: 'Collection 1',
              image_count: 2,
              sub_collection_count: 0,
              sub_collections: []
            },
            {
              name: 'Collection 2',
              image_count: 1,
              sub_collection_count: 0,
              sub_collections: []
            }
          ]
        end

        before do
          collection_image_1
          collection_image_2
          collection_image_3
        end

        it 'returns details for each collection' do
          expect(service.call[:collection_data]).to eq expected_data
        end
      end

      context 'when there the collection contains sub-collections' do
        let(:sub_collection_1) { create(:collection, name: 'Sub-Collection 1', parent: collection_1.id) }
        let(:image_1) { create(:image) }
        let(:collection_image_1) { create(:collection_image, image: image_1.id, collection: sub_collection_1.id) }

        before do
          collection_image_1
        end

        context 'for a single sub-collection' do
          let(:expected_data) do
            [
              {
                name: 'Collection 1',
                image_count: 0,
                sub_collection_count: 1,
                sub_collections: ['Sub-Collection 1']
              },
              {
                name: 'Sub-Collection 1',
                image_count: 1,
                sub_collection_count: 0,
                sub_collections: []
              }
            ]
          end

          it 'returns the name and count of the sub-collection' do
            expect(service.call[:collection_data]).to eq expected_data
          end
        end

        context 'when there is more than one sub-collection' do
          let(:sub_collection_2) { create(:collection, name: 'Sub-Collection 2', parent: collection_1.id) }
          let(:image_2) { create(:image) }
          let(:image_3) { create(:image) }
          let(:collection_image_2) { create(:collection_image, image: image_2.id, collection: sub_collection_2.id) }
          let(:collection_image_3) { create(:collection_image, image: image_3.id, collection: sub_collection_2.id) }

          let(:expected_data) do
            [
              {
                name: 'Collection 1',
                image_count: 0,
                sub_collection_count: 2,
                sub_collections: ['Sub-Collection 1', 'Sub-Collection 2']
              },
              {
                name: 'Sub-Collection 1',
                image_count: 1,
                sub_collection_count: 0,
                sub_collections: []
              },
              {
                name: 'Sub-Collection 2',
                image_count: 2,
                sub_collection_count: 0,
                sub_collections: []
              }
            ]
          end

          before do
            collection_image_2
            collection_image_3
          end

          it 'includes details for all the sub-collections' do
            expect(service.call[:collection_data]).to eq expected_data
          end
        end
      end
    end
  end
end
