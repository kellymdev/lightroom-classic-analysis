# frozen_string_literal: true

class CalculateHealthCheckData
  def call
    without_keywords = images_without_keywords

    {
      images_without_keywords: {
        count: without_keywords,
        percentage: calculate_percentage(without_keywords)
      }
    }
  end

  private

  def images_without_keywords
    Image.where.not(id_local: keyword_image_ids).count
  end

  def keyword_image_ids
    KeywordImage.pluck(:image)
  end

  def calculate_percentage(value)
    if value.zero?
      0.to_d
    else
      (value / Image.count.to_d * 100).round(2)
    end
  end
end
