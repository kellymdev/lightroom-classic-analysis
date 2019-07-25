# frozen_string_literal: true

class CalculateDataByCameraAndLens
  attr_reader :camera_name, :lens_name, :year

  def initialize(camera_name, lens_name, year)
    @camera_name = camera_name
    @lens_name = lens_name
    @year = year
  end

  def call
    {
      camera: camera_name,
      lens: lens_name,
      years_covered: years_covered,
      keywords: keywords_by_camera_and_lens,
      focal_lengths: focal_lengths_by_camera_and_lens,
      shutter_speeds: shutter_speeds_by_camera_and_lens,
      isos: isos_by_camera_and_lens,
      months: months_by_camera_and_lens
    }
  end

  private

  def years_covered
    year.presence || 'All years'
  end

  def keywords_by_camera_and_lens
    image_ids = exif_scope.pluck(:image)
    keyword_ids = KeywordImage.by_image(image_ids).pluck(:tag)
    frequencies = calculate_frequently_used(keyword_ids)

    frequencies.flat_map do |frequency|
      Keyword.where(id_local: frequency).pluck(:lc_name)
    end
  end

  def focal_lengths_by_camera_and_lens
    focal_lengths = exif_scope.pluck(:focalLength)

    results = calculate_frequently_used(focal_lengths)
    results.map { |result| result.round }
  end

  def shutter_speeds_by_camera_and_lens
    shutter_speeds = exif_scope.map do |exif|
      exif.shutter_speed_value
    end.compact

    calculate_frequently_used(shutter_speeds)
  end

  def isos_by_camera_and_lens
    isos = exif_scope.pluck(:isoSpeedRating)

    results = calculate_frequently_used(isos)
    results.map { |result| result.round }
  end

  def months_by_camera_and_lens
    months = exif_scope.pluck(:dateMonth)

    results = calculate_frequently_used(months)
    results.map do |result|
      Date::MONTHNAMES[result]
    end
  end

  def calculate_frequently_used(frequency_data)
    FrequencyCalculator.calculate_frequently_used(frequency_data, 5)
  end

  def camera_ids
    @camera_ids ||= Camera.for_model_name(camera_name).pluck(:id_local)
  end

  def lens_ids
    @lens_ids ||= Lens.for_model_name(lens_name).pluck(:id_local)
  end

  def exif_scope
    @exif_scope ||= if year.present?
      Exif.by_camera(camera_ids).by_lens(lens_ids).by_year(year.to_i)
    else
      Exif.by_camera(camera_ids).by_lens(lens_ids)
    end
  end
end
