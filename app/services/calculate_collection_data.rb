# frozen_string_literal: true

class CalculateCollectionData
  def call
    {
      collection_count: collection_count,
      images_in_collections: images_in_collections,
      collection_data: collection_data
    }
  end

  private

  def viewable_collections
    Collection.viewable
  end

  def collection_count
    viewable_collections.count
  end

  def images_in_collections
    CollectionImage.where(collection: viewable_collections.pluck(:id_local)).count
  end

  def collection_data
    viewable_collections.map do |collection|
      {
        name: collection.name,
        image_count: image_count_for(collection),
        sub_collection_count: sub_collection_count_for(collection),
        sub_collections: sub_collections_for(collection).pluck(:name)
      }
    end
  end

  def image_count_for(collection)
    CollectionImage.where(collection: collection.id).count
  end

  def sub_collection_count_for(collection)
    sub_collections_for(collection).count
  end

  def sub_collections_for(collection)
    Collection.viewable.where(parent: collection.id)
  end
end
