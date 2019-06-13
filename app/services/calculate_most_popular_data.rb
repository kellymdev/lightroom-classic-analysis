# frozen_string_literal: true

class CalculateMostPopularData
  def call
    {
      camera: most_frequent_camera,
      lens: most_frequent_lens,
      focal_length: most_frequent_focal_length,
      iso: most_frequent_iso,
      shutter_speed: most_frequent_shutter_speed,
      month: most_frequent_month,
      year: most_frequent_year
    }
  end

  private

  def most_frequent_camera
    model_ids = Exif.pluck(:cameraModelRef).compact
    calculate_most_frequent_from_model(model_ids, Camera)
  end

  def most_frequent_lens
    model_ids = Exif.pluck(:lensRef).compact
    calculate_most_frequent_from_model(model_ids, Lens)
  end

  def calculate_most_frequent_from_model(model_ids, klass_name)
    FrequencyCalculator.calculate_most_frequent_from_model(model_ids, klass_name)
  end

  def most_frequent_focal_length
    focal_lengths = Exif.pluck(:focalLength)
    calculate_frequencies(focal_lengths)
  end

  def most_frequent_iso
    isos = Exif.pluck(:isoSpeedRating)
    calculate_frequencies(isos)&.round
  end

  def most_frequent_shutter_speed
    shutter_speeds = Exif.all.map do |exif|
      next unless exif.shutterSpeed.present?

      exif.shutter_speed_value
    end.compact

    calculate_frequencies(shutter_speeds)
  end

  def most_frequent_month
    months = Exif.pluck(:dateMonth)

    month = calculate_frequencies(months)&.to_i

    if month.present?
      Date::MONTHNAMES[month]
    end
  end

  def most_frequent_year
    years = Exif.pluck(:dateYear)
    calculate_frequencies(years)&.round
  end

  def calculate_frequencies(data)
    FrequencyCalculator.calculate_most_frequent(data)
  end
end
