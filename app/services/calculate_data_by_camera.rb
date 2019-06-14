# frozen_string_literal: true

class CalculateDataByCamera
  attr_reader :camera_name

  def initialize(camera_name)
    @camera_name = camera_name
  end

  def call
    {
      camera: camera_name,
      keywords: keywords_by_camera
    }
  end

  private

  def keywords_by_camera
    image_ids = Exif.by_camera(camera_ids).pluck(:image)
    keyword_ids = KeywordImage.by_image(image_ids).pluck(:tag)
    keywords = Keyword.where(id_local: keyword_ids).pluck(:lc_name)

    calculate_frequently_used(keywords)
  end

  def calculate_frequently_used(frequency_data)
    FrequencyCalculator.calculate_frequently_used(frequency_data, 5)
  end

  def camera_ids
    @camera_ids ||= Camera.for_model_name(camera_name).pluck(:id_local)
  end
end
