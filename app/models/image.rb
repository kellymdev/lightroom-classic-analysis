# frozen_string_literal: true

class Image < ApplicationRecord
  self.table_name = 'Adobe_images'

  scope :unrated, -> { where(rating: nil) }
  scope :rated, -> { where.not(rating: nil) }
  scope :with_star_rating, ->(rating) { where(rating: rating) }
end
