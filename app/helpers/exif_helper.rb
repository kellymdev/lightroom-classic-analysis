# frozen_string_literal: true

module ExifHelper
  def years_for_select
    years = Exif.pluck(:dateYear).compact.uniq.sort.reverse.map(&:round)

    years.map do |year|
      [year, year]
    end
  end
end
