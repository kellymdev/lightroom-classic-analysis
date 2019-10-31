# frozen_string_literal: true

class CalculateKeywordData
  def call
    {
      most_frequent_keywords: most_frequent_keywords,
      most_frequent_wildlife_keywords: most_frequent_keywords_from_exif(Exif.wildlife),
      most_frequent_landscape_keywords: most_frequent_keywords_from_exif(Exif.wide_angle_landscape),
      most_frequent_macro_keywords: most_frequent_keywords_from_exif(Exif.macro),
      most_frequent_astro_keywords: most_frequent_keywords_from_exif(Exif.astro)
    }
  end

  private

  def most_frequent_keywords
    keyword_ids = KeywordImage.pluck(:tag)
    calculate_most_frequent_keywords(keyword_ids)
  end

  def most_frequent_keywords_from_exif(exif_scope)
    image_ids = exif_scope.pluck(:image)
    keyword_ids = KeywordImage.where(image: image_ids).pluck(:tag)
    calculate_most_frequent_keywords(keyword_ids)
  end

  def calculate_most_frequent_keywords(keyword_ids)
    frequent_keyword_ids = calculate_frequently_used(keyword_ids)

    frequent_keyword_ids.each do |keyword_id|
      keyword_id[:value] = Keyword.find_by(id_local: keyword_id[:value])&.lc_name
    end.compact
  end

  def calculate_frequently_used(data)
    FrequencyCalculator.calculate_frequently_used(data, 20)
  end
end
