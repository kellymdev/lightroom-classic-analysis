# frozen_string_literal: true

class FrequencyCalculator

  # Frequencies for string or numeric values
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

  # Frequencies from models (e.g. camera, lens)
  def self.calculate_most_frequent_from_model(model_ids, klass_name)
    frequencies = calculate_frequencies_for_model(model_ids, klass_name)
    total_frequencies = compare_frequencies_by_model_name(frequencies)
    total_frequencies.max_by { |model_name, frequency| frequency }&.first
  end

  def self.calculate_frequently_used_from_model(model_ids, klass_name, number_of_results)
    frequencies = calculate_frequencies_for_model(model_ids, klass_name)
    total_frequencies = compare_frequencies_by_model_name(frequencies)
    sorted = total_frequencies.sort { |a, b| b.second <=> a.second }

    results = sorted.take(number_of_results)
    results.map { |result| result.first }
  end

  def self.calculate_frequencies_for_model(model_ids, klass_name)
    frequencies = {}

    model_ids.each do |model_id|
      if frequencies.key?(model_id)
        frequencies[model_id][:frequency] += 1
      else
        frequencies[model_id] = {
          frequency: 1,
          model_name: klass_name.find_by(id_local: model_id).value
        }
      end
    end

    frequencies
  end

  def self.compare_frequencies_by_model_name(frequencies)
    grouped_by_name = frequencies.group_by { |model_id, data| data[:model_name] }

    total_frequencies = {}

    grouped_by_name.map do |model_name, data|
      frequency = data.map do |frequency_data|
        frequency_data.second[:frequency]
      end.reduce(:+)

      total_frequencies[model_name] = frequency
    end

    total_frequencies
  end
end
