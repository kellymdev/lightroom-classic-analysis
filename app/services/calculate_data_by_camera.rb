# frozen_string_literal: true

class CalculateDataByCamera
  attr_reader :camera_name, :year

  def initialize(camera_name, year)
    @camera_name = camera_name
    @year = year
  end

  def call
    {
      camera: camera_name,
      years_covered: years_covered,
      keywords: keywords_by_camera,
      lenses: lenses_by_camera,
      focal_lengths: focal_lengths_by_camera,
      shutter_speeds: shutter_speeds_by_camera,
      isos: isos_by_camera,
      ratings: ratings_by_camera,
      months: months_by_camera,
      years: years_by_camera,
      month_year_combinations: month_year_combinations_by_camera
    }
  end

  private

  def years_covered
    year.presence || 'All years'
  end

  def keywords_by_camera
    keyword_ids = KeywordImage.by_image(image_ids).pluck(:tag)
    frequencies = calculate_frequently_used(keyword_ids)

    frequencies.flat_map do |frequency|
      Keyword.where(id_local: frequency).pluck(:lc_name)
    end
  end

  def lenses_by_camera
    lens_ids = exif_scope.pluck(:lensRef).compact
    FrequencyCalculator.calculate_frequently_used_from_model(lens_ids, Lens, 5)
  end

  def focal_lengths_by_camera
    focal_lengths = exif_scope.pluck(:focalLength)

    results = calculate_frequently_used(focal_lengths)
    results.map(&:round)
  end

  def shutter_speeds_by_camera
    shutter_speeds = exif_scope.map(&:shutter_speed_value).compact

    calculate_frequently_used(shutter_speeds)
  end

  def isos_by_camera
    isos = exif_scope.pluck(:isoSpeedRating)

    results = calculate_frequently_used(isos)
    results.map(&:round)
  end

  def ratings_by_camera
    image_scope = Image.where(id_local: image_ids)

    CalculateRatingsData.new(image_scope).call
  end

  def months_by_camera
    months = exif_scope.pluck(:dateMonth)

    results = calculate_frequently_used(months)
    results.map do |result|
      Date::MONTHNAMES[result]
    end
  end

  def years_by_camera
    years = exif_scope.pluck(:dateYear)

    results = calculate_frequently_used(years)
    results.map(&:round)
  end

  def month_year_combinations_by_camera
    month_years = exif_scope.map(&:month_and_year).compact

    calculate_frequently_used(month_years)
  end

  def calculate_frequently_used(frequency_data)
    FrequencyCalculator.calculate_frequently_used(frequency_data, 5)
  end

  def image_ids
    @image_ids ||= exif_scope.pluck(:image)
  end

  def camera_ids
    @camera_ids ||= Camera.for_model_name(camera_name).pluck(:id_local)
  end

  def exif_scope
    @exif_scope ||= if year.present?
                      Exif.by_camera(camera_ids).by_year(year.to_i)
                    else
                      Exif.by_camera(camera_ids)
                    end
  end
end
