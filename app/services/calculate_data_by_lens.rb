# frozen_string_literal: true

class CalculateDataByLens
  attr_reader :lens_name, :year

  def initialize(lens_name, year)
    @lens_name = lens_name
    @year = year
  end

  def call
    {
      lens: lens_name,
      years_covered: years_covered,
      keywords: keywords_by_lens,
      cameras: cameras_by_lens,
      focal_lengths: focal_lengths_by_lens,
      shutter_speeds: shutter_speeds_by_lens,
      isos: isos_by_lens,
      ratings: ratings_by_lens,
      months: months_by_lens,
      years: years_by_lens,
      month_year_combinations: month_year_combinations_by_lens
    }
  end

  private

  def years_covered
    year.presence || 'All years'
  end

  def keywords_by_lens
    keyword_ids = KeywordImage.by_image(image_ids).pluck(:tag)
    frequencies = calculate_frequently_used(keyword_ids)

    frequencies.each do |frequency|
      frequency[:value] = Keyword.where(id_local: frequency[:value]).pluck(:lc_name).join
    end
  end

  def cameras_by_lens
    camera_ids = exif_scope.pluck(:cameraModelRef).compact
    FrequencyCalculator.calculate_frequently_used_from_model(camera_ids, Camera, 5)
  end

  def focal_lengths_by_lens
    focal_lengths = exif_scope.pluck(:focalLength)

    results = calculate_frequently_used(focal_lengths)
    results.each do |result|
      result[:value] = result[:value].round
    end
  end

  def shutter_speeds_by_lens
    shutter_speeds = exif_scope.map(&:shutter_speed_value).compact

    calculate_frequently_used(shutter_speeds)
  end

  def isos_by_lens
    isos = exif_scope.pluck(:isoSpeedRating)
    results = calculate_frequently_used(isos)
    results.each do |result|
      result[:value] = result[:value].round
    end
  end

  def ratings_by_lens
    images = Image.where(id_local: image_ids)

    CalculateRatingsData.new(images).call
  end

  def months_by_lens
    months = exif_scope.pluck(:dateMonth)

    results = calculate_frequently_used(months)
    results.each do |result|
      result[:value] = Date::MONTHNAMES[result[:value]]
    end
  end

  def years_by_lens
    years = exif_scope.pluck(:dateYear)

    results = calculate_frequently_used(years)
    results.each do |result|
      result[:value] = result[:value].round
    end
  end

  def month_year_combinations_by_lens
    month_years = exif_scope.map(&:month_and_year).compact

    calculate_frequently_used(month_years)
  end

  def calculate_frequently_used(frequency_data)
    FrequencyCalculator.calculate_frequently_used(frequency_data, 5)
  end

  def image_ids
    @image_ids ||= exif_scope.pluck(:image)
  end

  def lens_ids
    @lens_ids ||= Lens.for_model_name(lens_name).pluck(:id_local)
  end

  def exif_scope
    @exif_scope ||= if year.present?
                      Exif.by_lens(lens_ids).by_year(year.to_i)
                    else
                      Exif.by_lens(lens_ids)
                    end
  end
end
