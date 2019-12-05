# frozen_string_literal: true

class EquipmentController < ApplicationController
  def index; end

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
