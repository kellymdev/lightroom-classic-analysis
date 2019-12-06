# frozen_string_literal: true

class CalculateDevelopSettingData
  def call
    {
      develop_steps: develop_steps,
      exposure: develop_data_as_decimal_for('Exposure'),
      contrast: develop_data_for('Contrast'),
      highlights: develop_data_for('Highlights'),
      shadows: develop_data_for('Shadows'),
      white_clipping: develop_data_for('White Clipping'),
      black_clipping: develop_data_for('Black Clipping'),
      texture: develop_data_for('Texture'),
      clarity: develop_data_for('Clarity'),
      dehaze: develop_data_for('Dehaze Amount'),
      post_crop_vignette_amount: develop_data_for('Post-Crop Vignette Amount'),
      vibrance: develop_data_for('Vibrance'),
      saturation: develop_data_for('Saturation'),
      white_balance: white_balance_data,
      crop_ratios: crop_ratio_data,
      process_versions: process_version_data
    }
  end

  private

  def develop_steps
    steps = DevelopHistoryStep.all.pluck(:name)
    calculate_frequently_used(steps, 10)
  end

  def develop_data_for(setting_name)
    {
      most_frequent: adjustments_for(setting_name),
      positive: average_positive_for(setting_name),
      negative: average_negative_for(setting_name)
    }
  end

  def develop_data_as_decimal_for(setting_name)
    {
      most_frequent: adjustments_for(setting_name),
      positive: average_positive_as_decimal_for(setting_name),
      negative: average_negative_as_decimal_for(setting_name)
    }
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

  def white_balance_data
    white_balances = DevelopSetting.pluck(:whiteBalance)
    calculate_frequently_used(white_balances)
  end

  def crop_ratio_data
    crop_ratios = DevelopSetting.cropped.map(&:crop_ratio)
    calculate_frequently_used(crop_ratios)
  end

  def process_version_data
    process_versions = DevelopSetting.pluck(:processVersion).compact
    calculate_frequently_used(process_versions)
  end

  def calculate_frequently_used(frequency_data, number_of_results = 10)
    FrequencyCalculator.calculate_frequently_used(frequency_data, number_of_results)
  end

  def calculate_average(adjustments)
    return unless adjustments.present?

    adjustments.reduce(:+) / adjustments.size
  end
end
