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
      ratings: ratings_by_camera_and_lens,
      months: months_by_camera_and_lens
    }
  end

  private

  def years_covered
    year.presence || 'All years'
  end

  def keywords_by_camera_and_lens
    keyword_ids = KeywordImage.by_image(image_ids).pluck(:tag)
    frequencies = calculate_frequently_used(keyword_ids)

    frequencies.each do |frequency|
      frequency[:value] = Keyword.where(id_local: frequency[:value]).pluck(:lc_name).join
    end
  end

  def focal_lengths_by_camera_and_lens
    focal_lengths = exif_scope.pluck(:focalLength)

    results = calculate_frequently_used(focal_lengths)
    results.each do |result|
      result[:value] = result[:value].round
    end
  end

  def shutter_speeds_by_camera_and_lens
    shutter_speeds = exif_scope.map(&:shutter_speed_value).compact

    calculate_frequently_used(shutter_speeds)
  end

  def isos_by_camera_and_lens
    isos = exif_scope.pluck(:isoSpeedRating)

    results = calculate_frequently_used(isos)
    results.each do |result|
      result[:value] = result[:value].round
    end
  end

  def ratings_by_camera_and_lens
    image_scope = Image.where(id_local: image_ids)

    CalculateRatingsData.new(image_scope).call
  end

  def months_by_camera_and_lens
    months = exif_scope.pluck(:dateMonth)

    results = calculate_frequently_used(months)
    results.each do |result|
      result[:value] = Date::MONTHNAMES[result[:value]]
    end
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
