# frozen_string_literal: true

class CalculateMostFrequentFromExif
  attr_reader :exif_scope, :number_of_results

  def initialize(exif_scope, number_of_results)
    @exif_scope = exif_scope
    @number_of_results = number_of_results
  end

  def call
    {
      cameras: most_frequent_cameras,
      lenses: most_frequent_lenses,
      camera_lens_combinations: most_frequent_camera_lens_combinations,
      focal_lengths: most_frequent_focal_lengths,
      isos: most_frequent_isos,
      shutter_speeds: most_frequent_shutter_speeds,
      months: most_frequent_months,
      years: most_frequent_years,
      month_year_combinations: most_frequent_month_years
    }
  end

  private

  def most_frequent_cameras
    model_ids = exif_scope.pluck(:cameraModelRef)
    calculate_most_frequently_used_from_model(model_ids, Camera)
  end

  def most_frequent_lenses
    model_ids = exif_scope.pluck(:lensRef)
    calculate_most_frequently_used_from_model(model_ids, Lens)
  end

  def calculate_most_frequently_used_from_model(model_ids, klass_name)
    FrequencyCalculator.calculate_frequently_used_from_model(model_ids, klass_name, number_of_results)
  end

  def most_frequent_camera_lens_combinations
    camera_lens_ids = exif_scope.pluck(:cameraModelRef, :lensRef)
    FrequencyCalculator.calculate_frequently_used_camera_and_lens(camera_lens_ids, number_of_results)
  end

  def most_frequent_focal_lengths
    focal_lengths = exif_scope.pluck(:focalLength)
    results = calculate_frequencies(focal_lengths)
    results.map { |focal_length| focal_length.round }
  end

  def most_frequent_isos
    isos = exif_scope.pluck(:isoSpeedRating)
    results = calculate_frequencies(isos)
    results.map { |iso| iso.round }
  end

  def most_frequent_shutter_speeds
    shutter_speeds = exif_scope.map do |exif|
      exif.shutter_speed_value
    end.compact

    calculate_frequencies(shutter_speeds)
  end

  def most_frequent_months
    months = exif_scope.pluck(:dateMonth)

    results = calculate_frequencies(months)
    results.map do |result|
      Date::MONTHNAMES[result]
    end
  end

  def most_frequent_years
    years = exif_scope.pluck(:dateYear)

    results = calculate_frequencies(years)
    results.map do |result|
      result.round
    end
  end

  def most_frequent_month_years
    month_years = exif_scope.map do |exif|
      exif.month_and_year
    end.compact

    calculate_frequencies(month_years)
  end

  def calculate_frequencies(data)
    FrequencyCalculator.calculate_frequently_used(data, 5)
  end
end
