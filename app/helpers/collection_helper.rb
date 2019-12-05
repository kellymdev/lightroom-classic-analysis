# frozen_string_literal: true

module CollectionHelper
  def collection_overview_text(collection_count)
    "There #{verb(collection_count)} #{pluralize(collection_count, 'collection')}"
  end

  private

  def verb(collection_count)
    collection_count == 1 ? 'is' : 'are'
  end
end
