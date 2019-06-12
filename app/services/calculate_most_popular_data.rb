# frozen_string_literal: true

class CalculateMostPopularData
  def call
    {
      camera: most_frequent_camera,
      lens: most_frequent_lens,
      focal_length: most_frequent_focal_length,
      iso: most_frequent_iso
    }
  end

  private

  def most_frequent_camera
    model_ids = Exif.pluck(:cameraModelRef).compact

    frequencies = calculate_frequencies_for_model(model_ids, Camera)
    compare_frequencies_by_model(frequencies)
  end

  def most_frequent_lens
    model_ids = Exif.pluck(:lensRef).compact

    frequencies = calculate_frequencies_for_model(model_ids, Lens)
    compare_frequencies_by_model(frequencies)
  end

  def calculate_frequencies_for_model(model_ids, klass_name)
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

  def compare_frequencies_by_model(frequencies)
    grouped_by_name = frequencies.group_by { |model_id, data| data[:model_name] }

    total_frequencies = {}

    grouped_by_name.map do |model_name, data|
      frequency = data.map do |frequency_data|
        frequency_data.second[:frequency]
      end.reduce(:+)

      total_frequencies[model_name] = frequency
    end

    total_frequencies.max_by { |model_name, frequency| frequency }.first
  end

  def most_frequent_focal_length
    focal_lengths = Exif.pluck(:focalLength)

    frequencies = calculate_frequencies(focal_lengths)
    frequencies.max_by { |focal_length, frequency| frequency }.first
  end

  def most_frequent_iso
    isos = Exif.pluck(:isoSpeedRating)

    frequencies = calculate_frequencies(isos)
    frequencies.max_by { |iso, frequency| frequency }.first.round
  end

  def calculate_frequencies(data)
    frequencies = {}

    data.each do |data_value|
      if frequencies.key?(data_value)
        frequencies[data_value] += 1
      else
        frequencies[data_value] = 1
      end
    end

    frequencies
  end
end
