# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    @image_count = Image.count

    @most_popular_data = CalculateMostPopularData.new.call
    @capture_time_data = CalculateCaptureTimeData.new.call
    @wildlife_data = CalculateMostFrequentFromExif.new(Exif.wildlife, 5).call
    @landscape_data = CalculateMostFrequentFromExif.new(Exif.wide_angle_landscape, 5).call
    @macro_data = CalculateMostFrequentFromExif.new(Exif.macro, 5).call
    @keyword_data = CalculateKeywordData.new.call
    @ratings_data = CalculateRatingsData.new(Image.all).call
    @develop_data = CalculateDevelopSettingData.new.call
  end

  def by_camera
    @data_by_camera = CalculateDataByCamera.new(params[:camera_name], params[:year]).call
  end

  def by_lens
    @data_by_lens = CalculateDataByLens.new(params[:lens_name], params[:year]).call
  end

  def by_camera_and_lens
    @data_by_camera_and_lens = CalculateDataByCameraAndLens.new(params[:camera_name], params[:lens_name], params[:year]).call
  end
end
