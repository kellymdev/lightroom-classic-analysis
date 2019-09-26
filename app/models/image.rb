# frozen_string_literal: true

class Image < ApplicationRecord
  self.table_name = 'Adobe_images'

  # Rating scopes
  scope :unrated, -> { where(rating: nil) }
  scope :rated, -> { where.not(rating: nil) }
  scope :with_star_rating, ->(rating) { where(rating: rating) }

  # Capture time scopes
  scope :for_month, ->(month) { where('captureTime LIKE ?', "%-#{month}-%") }
  scope :for_year, ->(year) { where('captureTime LIKE ?', "#{year}-%") }

  def capture_hour
    if captureTime.is_a?(DateTime) || captureTime.is_a?(Time)
      captureTime.hour
    else
      Time.parse(captureTime).hour
    end
  end
end
