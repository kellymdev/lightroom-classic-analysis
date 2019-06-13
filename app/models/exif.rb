# frozen_string_literal: true

class Exif < ApplicationRecord
  self.table_name = 'AgHarvestedExifMetadata'

  scope :wildlife, -> { where('focalLength >= ?', 300.0) }

  def shutter_speed_value
    (2**shutterSpeed).round
  end
end
