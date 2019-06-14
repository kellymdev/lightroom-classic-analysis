# frozen_string_literal: true

class CalculateDataByLens
  attr_reader :lens_name

  def initialize(lens_name)
    @lens_name = lens_name
  end

  def call
    {
      lens: lens_name,
      keywords: keywords_by_lens
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

  def calculate_frequently_used(frequency_data)
    FrequencyCalculator.calculate_frequently_used(frequency_data, 5)
  end

  def lens_ids
    @lens_ids ||= Lens.for_model_name(lens_name).pluck(:id_local)
  end
end
