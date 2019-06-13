# frozen_string_literal: true

class CalculateWildlifeData
  def call
    {
      cameras: most_frequent_cameras,
      lenses: most_frequent_lenses,
      camera_lens_combinations: most_frequent_camera_lens_combinations,
      focal_lengths: most_frequent_focal_lengths,
      isos: most_frequent_isos,
      shutter_speeds: most_frequent_shutter_speeds,
      month: most_frequent_month,
      year: most_frequent_year,
      month_year_combinations: most_frequent_month_years
    }
  end

  private

  def most_frequent_cameras
    model_ids = Exif.wildlife.pluck(:cameraModelRef)
    calculate_most_frequently_used_from_model(model_ids, Camera)
  end

  def most_frequent_lenses
    model_ids = Exif.wildlife.pluck(:lensRef)
    calculate_most_frequently_used_from_model(model_ids, Lens)
  end

  def calculate_most_frequently_used_from_model(model_ids, klass_name)
    FrequencyCalculator.calculate_frequently_used_from_model(model_ids, klass_name, 5)
  end

  def most_frequent_camera_lens_combinations
    camera_lens_ids = Exif.wildlife.pluck(:cameraModelRef, :lensRef)
    FrequencyCalculator.calculate_frequently_used_camera_and_lens(camera_lens_ids, 5)
  end

  def most_frequent_focal_lengths
    focal_lengths = Exif.wildlife.pluck(:focalLength)
    results = calculate_frequencies(focal_lengths)
    results.map { |focal_length| focal_length.round }
  end

  def most_frequent_isos
    isos = Exif.wildlife.pluck(:isoSpeedRating)
    results = calculate_frequencies(isos)
    results.map { |iso| iso.round }
  end

  def most_frequent_shutter_speeds
    shutter_speeds = Exif.wildlife.map do |exif|
      exif.shutter_speed_value
    end.compact

    calculate_frequencies(shutter_speeds)
  end

  def most_frequent_month
    months = Exif.wildlife.pluck(:dateMonth)
    month = calculate_most_frequent(months)&.to_i

    if month.present?
      Date::MONTHNAMES[month]
    end
  end

  def most_frequent_year
    years = Exif.wildlife.pluck(:dateYear)
    calculate_most_frequent(years)&.to_i
  end

  def most_frequent_month_years
    month_years = Exif.wildlife.map do |exif|
      exif.month_and_year
    end.compact

    calculate_frequencies(month_years)
  end

  def calculate_frequencies(data)
    FrequencyCalculator.calculate_frequently_used(data, 5)
  end

  def calculate_most_frequent(data)
    FrequencyCalculator.calculate_most_frequent(data)
  end
end
