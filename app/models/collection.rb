# frozen_string_literal: true

class Collection < ApplicationRecord
  self.table_name = 'AgLibraryCollection'

  scope :viewable, -> { where(systemOnly: 0) }
end
