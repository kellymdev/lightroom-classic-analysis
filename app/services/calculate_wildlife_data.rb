# frozen_string_literal: true

class CalculateWildlifeData
  def call
    {
      focal_lengths: most_frequent_focal_lengths,
      isos: most_frequent_isos,
      month: most_frequent_month,
      year: most_frequent_year
    }
  end

  private

  def most_frequent_focal_lengths
    focal_lengths = Exif.wildlife.pluck(:focalLength)
    results = calculate_frequencies(focal_lengths)
    results.map { |focal_length| focal_length.round }
  end

  def most_frequent_isos
    isos = Exif.wildlife.pluck(:isoSpeedRating)
    results = calculate_frequencies(isos)
    results.map { |iso| iso.round }
  end

  def most_frequent_month
    months = Exif.wildlife.pluck(:dateMonth)
    month = calculate_most_frequent(months)&.to_i

    if month.present?
      Date::MONTHNAMES[month]
    end
  end

  def most_frequent_year
    years = Exif.wildlife.pluck(:dateYear)
    calculate_most_frequent(years)&.round
  end

  def calculate_frequencies(data)
    FrequencyCalculator.calculate_frequently_used(data, 5)
  end

  def calculate_most_frequent(data)
    FrequencyCalculator.calculate_most_frequent(data)
  end
end
