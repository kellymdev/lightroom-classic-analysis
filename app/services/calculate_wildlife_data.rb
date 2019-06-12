# frozen_string_literal: true

class CalculateWildlifeData
  def call
    {
      focal_lengths: most_frequent_focal_lengths,
    }
  end

  private

  def most_frequent_focal_lengths
    focal_lengths = Exif.wildlife.pluck(:focalLength)
    results = calculate_frequencies(focal_lengths)
    results.map { |focal_length| focal_length.round }
  end

  def calculate_frequencies(data)
    FrequencyCalculator.calculate_frequently_used(data, 5)
  end
end
