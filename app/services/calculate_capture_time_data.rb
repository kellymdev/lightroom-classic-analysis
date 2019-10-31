# frozen_string_literal: true

class CalculateCaptureTimeData
  def call
    {
      january: capture_time_for_month('01'),
      february: capture_time_for_month('02'),
      march: capture_time_for_month('03'),
      april: capture_time_for_month('04'),
      may: capture_time_for_month('05'),
      june: capture_time_for_month('06'),
      july: capture_time_for_month('07'),
      august: capture_time_for_month('08'),
      september: capture_time_for_month('09'),
      october: capture_time_for_month('10'),
      november: capture_time_for_month('11'),
      december: capture_time_for_month('12')
    }
  end

  private

  def capture_time_for_month(month_num)
    images = Image.for_month(month_num)
    hours = images.map(&:capture_hour)

    most_frequent = calculate_frequencies(hours)
    format_time_range(most_frequent)
  end

  def format_time_range(most_frequent)
    most_frequent.each do |hour|
      formatted_hour = format_hour(hour[:value])

      hour[:value] = "#{formatted_hour}:00 - #{formatted_hour}:59"
    end

    most_frequent
  end

  def format_hour(hour)
    format('%02d', hour)
  end

  def calculate_frequencies(data)
    FrequencyCalculator.calculate_frequently_used(data, 5)
  end
end
