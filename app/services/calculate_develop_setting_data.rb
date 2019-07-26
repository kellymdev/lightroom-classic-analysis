# frozen_string_literal: true

class CalculateDevelopSettingData
  def call
    {
      develop_steps: develop_steps,
      exposure: adjustments_for('Exposure'),
      contrast: adjustments_for('Contrast'),
      highlights: adjustments_for('Highlights'),
      shadows: adjustments_for('Shadows'),
      white_clipping: adjustments_for('White Clipping'),
      black_clipping: adjustments_for('Black Clipping'),
      clarity: adjustments_for('Clarity'),
      post_crop_vignette_amount: adjustments_for('Post-Crop Vignette Amount'),
      vibrance: adjustments_for('Vibrance'),
      saturation: adjustments_for('Saturation'),
      averages: {
        positive_exposure: average_positive_for('Exposure'),
      }
    }
  end

  private

  def develop_steps
    steps = DevelopHistoryStep.all.pluck(:name)
    calculate_frequently_used(steps, 10)
  end

  def adjustments_for(setting_name)
    adjustments = DevelopHistoryStep.for_setting(setting_name).pluck(:valueString)
    calculate_frequently_used(adjustments)
  end

  def average_positive_for(setting_name)
    adjustments = DevelopHistoryStep.for_setting(setting_name).positive.pluck(:valueString).map(&:to_i)
    calculate_average(adjustments)
  end

  def calculate_frequently_used(frequency_data, number_of_results = 5)
    FrequencyCalculator.calculate_frequently_used(frequency_data, number_of_results)
  end

  def calculate_average(adjustments)
    return unless adjustments.present?

    adjustments.reduce(:+) / adjustments.size
  end
end
