# frozen_string_literal: true

class Exif < ApplicationRecord
  self.table_name = 'AgHarvestedExifMetadata'

  scope :wildlife, -> { where('focalLength >= ?', 200.0) }
  scope :wide_angle_landscape, -> { where('focalLength <= ? AND isoSpeedRating = ?', 35.0, 100.0).by_camera(Camera.canon_dslr.pluck(:id_local)) }
  scope :macro, -> { by_lens(Lens.macro.pluck(:id_local)) }
  scope :astro, -> { where('aperture <= ? AND isoSpeedRating >= ?', 4.0, 3200.0) }
  scope :by_camera, ->(camera_id) { where(cameraModelRef: camera_id) }
  scope :by_lens, ->(lens_id) { where(lensRef: lens_id) }
  scope :by_year, ->(year) { where(dateYear: year) }

  def shutter_speed_value
    return unless shutterSpeed.present?

    if shutterSpeed.negative?
      (2**-shutterSpeed).round
    else
      speed = (2**shutterSpeed).round
      format_speed(speed)
    end
  end

  def month_and_year
    return unless dateMonth.present? && dateYear.present?

    "#{Date::MONTHNAMES[dateMonth]} #{dateYear.to_i}"
  end

  private

  def format_speed(speed)
    if speed == 1
      1
    else
      "1/#{speed}".to_r
    end
  end
end
