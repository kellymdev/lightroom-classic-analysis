# frozen_string_literal: true

module LensHelper
  def lenses_for_select
    Lens.pluck(:value).uniq.sort.map do |lens_name|
      [lens_name, lens_name]
    end
  end
end
