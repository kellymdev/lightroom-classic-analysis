# frozen_string_literal: true

class Lens < ApplicationRecord
  self.table_name = 'AgInternedExifLens'

  scope :for_model_name, ->(model_name) { where(value: model_name) }
end
