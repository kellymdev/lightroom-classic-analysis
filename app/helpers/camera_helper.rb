# frozen_string_literal: true

module CameraHelper
  def cameras_for_select
    camera_names = Camera.pluck(:value).uniq.sort

    camera_names.map do |name|
      [name, name]
    end
  end
end
