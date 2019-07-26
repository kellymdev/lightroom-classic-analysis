# frozen_string_literal: true

class DevelopHistoryStep < ApplicationRecord
  self.table_name = 'Adobe_libraryImageDevelopHistoryStep'

  scope :for_setting, ->(setting_name) { where("name = ?", setting_name) }
  scope :negative, -> { where("valueString LIKE ?", "-%") }
  scope :positive, -> { where.not("valueString LIKE ?", "-%") }
end
