# frozen_string_literal: true

class Camera < ApplicationRecord
  self.table_name = 'AgInternedExifCameraModel'

  scope :for_model_name, ->(model_name) { where('value = ?', model_name) }
end
