# frozen_string_literal: true

module FrequencyValuesHelper
  def display_value(value)
    case value
    when true
      'Yes'
    when false
      'No'
    else
      value
    end
  end
end
