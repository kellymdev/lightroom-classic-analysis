# frozen_string_literal: true

class KeywordImage < ApplicationRecord
  self.table_name = 'AgLibraryKeywordImage'

  scope :by_image, ->(image_id) { where(image: image_id) }
end
