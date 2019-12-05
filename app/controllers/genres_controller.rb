# frozen_string_literal: true

class GenresController < ApplicationController
  def wildlife_data
    @wildlife_data = CalculateMostFrequentFromExif.new(Exif.wildlife, 5).call
  end

  def landscape_data
    @landscape_data = CalculateMostFrequentFromExif.new(Exif.wide_angle_landscape, 5).call
  end

  def macro_data
    @macro_data = CalculateMostFrequentFromExif.new(Exif.macro, 5).call
  end

  def astro_data
    @astro_data = CalculateMostFrequentFromExif.new(Exif.astro, 5).call
  end
end
