# frozen_string_literal: true

class Exif < ApplicationRecord
  self.table_name = 'AgHarvestedExifMetadata'

  scope :wildlife, -> { where('focalLength >= ?', 300.0) }
  scope :wide_angle_landscape, -> { where('focalLength <= ? AND isoSpeedRating = ?', 35.0, 100.0) }
  scope :by_camera, ->(camera_id) { where(cameraModelRef: camera_id) }
  scope :by_lens, ->(lens_id) { where(lensRef: lens_id) }
  scope :by_year, ->(year) { where(dateYear: year) }

  def shutter_speed_value
    return unless shutterSpeed.present?

    (2**shutterSpeed).round
  end

  def month_and_year
    return unless dateMonth.present? && dateYear.present?

    "#{Date::MONTHNAMES[dateMonth]} #{dateYear.to_i}"
  end
end
