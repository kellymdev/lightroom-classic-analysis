# frozen_string_literal: true

class FrequencyCalculator
  def self.calculate_most_frequent(frequency_data)
    frequencies = calculate_frequencies(frequency_data)
    frequencies.max_by { |data_value, frequency| frequency }&.first
  end

  def self.calculate_frequently_used(frequency_data, number_of_results)
    frequencies = calculate_frequencies(frequency_data)
    sorted = frequencies.sort { |a, b| b.second <=> a.second }

    results = sorted.take(number_of_results)
    results.map { |result| result.first }
  end

  def self.calculate_frequencies(frequency_data)
    frequencies = {}

    frequency_data.each do |data_value|
      if frequencies.key?(data_value)
        frequencies[data_value] += 1
      else
        frequencies[data_value] = 1
      end
    end

    frequencies
  end
end
