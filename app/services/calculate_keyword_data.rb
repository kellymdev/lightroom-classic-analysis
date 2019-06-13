# frozen_string_literal: true

class CalculateKeywordData
  def call
    {
      most_frequent_keywords: most_frequent_keywords,
      most_frequent_wildlife_keywords: most_frequent_wildlife_keywords
    }
  end

  private

  def most_frequent_keywords
    keyword_ids = KeywordImage.pluck(:tag)
    calculate_most_frequent_keywords(keyword_ids)
  end

  def most_frequent_wildlife_keywords
    wildlife_image_ids = Exif.wildlife.pluck(:image)
    keyword_ids = KeywordImage.where(:image => wildlife_image_ids).pluck(:tag)
    calculate_most_frequent_keywords(keyword_ids)
  end

  def calculate_most_frequent_keywords(keyword_ids)
    frequent_keyword_ids = calculate_frequently_used(keyword_ids)

    frequent_keyword_ids.map do |keyword_id|
      Keyword.find_by(:id_local => keyword_id)&.lc_name
    end.compact
  end

  def calculate_frequently_used(data)
    FrequencyCalculator.calculate_frequently_used(data, 20)
  end
end