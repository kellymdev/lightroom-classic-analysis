# frozen_string_literal: true

class CollectionsController < ApplicationController
  def index
    @collection_data = CalculateCollectionData.new.call
  end
end
