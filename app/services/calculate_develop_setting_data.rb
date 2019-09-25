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
        positive_exposure: average_positive_as_decimal_for('Exposure'),
        negative_exposure: average_negative_as_decimal_for('Exposure'),
        positive_contrast: average_positive_for('Contrast'),
        negative_contrast: average_negative_for('Contrast'),
        positive_highlights: average_positive_for('Highlights'),
        negative_highlights: average_negative_for('Highlights'),
        positive_shadows: average_positive_for('Shadows'),
        negative_shadows: average_negative_for('Shadows'),
        positive_white_clipping: average_positive_for('White Clipping'),
        negative_white_clipping: average_negative_for('White Clipping'),
        positive_black_clipping: average_positive_for('Black Clipping'),
        negative_black_clipping: average_negative_for('Black Clipping'),
        positive_clarity: average_positive_for('Clarity'),
        negative_clarity: average_negative_for('Clarity'),
        positive_post_crop_vignette_amount: average_positive_for('Post-Crop Vignette Amount'),
        negative_post_crop_vignette_amount: average_negative_for('Post-Crop Vignette Amount'),
        positive_vibrance: average_positive_for('Vibrance'),
        negative_vibrance: average_negative_for('Vibrance'),
        positive_saturation: average_positive_for('Saturation'),
        negative_saturation: average_negative_for('Saturation')
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

  def average_positive_as_decimal_for(setting_name)
    adjustments = DevelopHistoryStep.for_setting(setting_name).positive.pluck(:valueString).map(&:to_d)
    calculate_average(adjustments)&.round(2)
  end

  def average_negative_as_decimal_for(setting_name)
    adjustments = DevelopHistoryStep.for_setting(setting_name).negative.pluck(:valueString).map(&:to_d)
    calculate_average(adjustments)&.round(2)
  end

  def average_positive_for(setting_name)
    adjustments = DevelopHistoryStep.for_setting(setting_name).positive.pluck(:valueString).map(&:to_i)
    calculate_average(adjustments)
  end

  def average_negative_for(setting_name)
    adjustments = DevelopHistoryStep.for_setting(setting_name).negative.pluck(:valueString).map(&:to_i)
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
