# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    @image_count = Image.count

    @most_popular_data = CalculateMostPopularData.new.call
    @wildlife_data = CalculateWildlifeData.new.call
    @keyword_data = CalculateKeywordData.new.call
  end
end
