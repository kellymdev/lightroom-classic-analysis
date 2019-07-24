# frozen_string_literal: true

class CalculateDataByLens
  attr_reader :lens_name

  def initialize(lens_name)
    @lens_name = lens_name
  end

  def call
    {
      lens: lens_name,
      keywords: keywords_by_lens,
      cameras: cameras_by_lens,
      focal_lengths: focal_lengths_by_lens,
      shutter_speeds: shutter_speeds_by_lens,
      isos: isos_by_lens,
      months: months_by_lens,
      years: years_by_lens,
      month_year_combinations: month_year_combinations_by_lens
    }
  end

  private

  def keywords_by_lens
    image_ids = Exif.by_lens(lens_ids).pluck(:image)
    keyword_ids = KeywordImage.by_image(image_ids).pluck(:tag)
    frequencies = calculate_frequently_used(keyword_ids)

    frequencies.flat_map do |frequency|
      Keyword.where(id_local: frequency).pluck(:lc_name)
    end
  end

  def cameras_by_lens
    camera_ids = Exif.by_lens(lens_ids).pluck(:cameraModelRef).compact
    FrequencyCalculator.calculate_frequently_used_from_model(camera_ids, Camera, 5)
  end

  def focal_lengths_by_lens
    focal_lengths = Exif.by_lens(lens_ids).pluck(:focalLength)

    results = calculate_frequently_used(focal_lengths)
    results.map { |result| result.round }
  end

  def shutter_speeds_by_lens
    shutter_speeds = Exif.by_lens(lens_ids).map do |exif|
      exif.shutter_speed_value
    end.compact

    calculate_frequently_used(shutter_speeds)
  end

  def isos_by_lens
    isos = Exif.by_lens(lens_ids).pluck(:isoSpeedRating)
    results = calculate_frequently_used(isos)
    results.map { |result| result.round }
  end

  def months_by_lens
    months = Exif.by_lens(lens_ids).pluck(:dateMonth)

    results = calculate_frequently_used(months)
    results.map do |result|
      Date::MONTHNAMES[result]
    end
  end

  def years_by_lens
    years = Exif.by_lens(lens_ids).pluck(:dateYear)

    results = calculate_frequently_used(years)
    results.map do |result|
      result.round
    end
  end

  def month_year_combinations_by_lens
    month_years = Exif.by_lens(lens_ids).map do |exif|
      exif.month_and_year
    end.compact

    calculate_frequently_used(month_years)
  end

  def calculate_frequently_used(frequency_data)
    FrequencyCalculator.calculate_frequently_used(frequency_data, 5)
  end

  def lens_ids
    @lens_ids ||= Lens.for_model_name(lens_name).pluck(:id_local)
  end
end
