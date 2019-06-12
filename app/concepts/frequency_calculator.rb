# frozen_string_literal: true

class FrequencyCalculator
  def self.calculate_frequencies(frequency_data)
    frequencies = {}

    frequency_data.each do |data_value|
      if frequencies.key?(data_value)
        frequencies[data_value] += 1
      else
        frequencies[data_value] = 1
      end
    end

    frequencies.max_by { |data_value, frequency| frequency }.first
  end
end
