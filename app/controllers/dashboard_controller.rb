# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    @image_count = Image.count

    @most_popular_data = CalculateMostPopularData.new.call
    @wildlife_data = CalculateMostFrequentFromExif.new(Exif.wildlife, 5).call
    @landscape_data = CalculateMostFrequentFromExif.new(Exif.wide_angle_landscape, 5).call
    @macro_data = CalculateMostFrequentFromExif.new(Exif.macro, 5).call
    @keyword_data = CalculateKeywordData.new.call
  end

  def by_camera
    @data_by_camera = CalculateDataByCamera.new(params[:camera_name]).call
  end

  def by_lens
    @data_by_lens = CalculateDataByLens.new(params[:lens_name]).call
  end
end
