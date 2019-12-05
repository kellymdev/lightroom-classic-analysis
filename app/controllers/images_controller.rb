# frozen_string_literal: true

class ImagesController < ApplicationController
  def capture_time_data
    @capture_time_data = CalculateCaptureTimeData.new.call
  end

  def keyword_data
    @keyword_data = CalculateKeywordData.new.call
  end

  def ratings_data
    @ratings_data = CalculateRatingsData.new(Image.all).call
  end
end
