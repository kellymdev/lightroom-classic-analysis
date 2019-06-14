# frozen_string_literal: true

class CalculateDataByCamera
  attr_reader :camera_name

  def initialize(camera_name)
    @camera_name = camera_name
  end

  def call
    {
      camera: camera_name,
      keywords: keywords_by_camera,
      focal_lengths: focal_lengths_by_camera,
      shutter_speeds: shutter_speeds_by_camera,
      isos: isos_by_camera
    }
  end

  private

  def keywords_by_camera
    image_ids = Exif.by_camera(camera_ids).pluck(:image)
    keyword_ids = KeywordImage.by_image(image_ids).pluck(:tag)
    keywords = Keyword.where(id_local: keyword_ids).pluck(:lc_name)

    calculate_frequently_used(keywords)
  end

  def focal_lengths_by_camera
    focal_lengths = Exif.by_camera(camera_ids).pluck(:focalLength)

    results = calculate_frequently_used(focal_lengths)
    results.map { |result| result.round }
  end

  def shutter_speeds_by_camera
    shutter_speeds = Exif.by_camera(camera_ids).map do |exif|
      exif.shutter_speed_value
    end.compact

    calculate_frequently_used(shutter_speeds)
  end

  def isos_by_camera
    isos = Exif.by_camera(camera_ids).pluck(:isoSpeedRating)

    results = calculate_frequently_used(isos)
    results.map { |result| result.round }
  end

  def calculate_frequently_used(frequency_data)
    FrequencyCalculator.calculate_frequently_used(frequency_data, 5)
  end

  def camera_ids
    @camera_ids ||= Camera.for_model_name(camera_name).pluck(:id_local)
  end
end
