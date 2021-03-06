# frozen_string_literal: true

class DevelopSetting < ApplicationRecord
  self.table_name = 'Adobe_imageDevelopSettings'

  UNCROPPED = 'uncropped'

  scope :cropped, -> { where.not(croppedWidth: UNCROPPED) }
  scope :developed, -> { where(hasDevelopAdjustmentsEx: 1.0) }

  def uncropped?
    croppedWidth == UNCROPPED
  end

  def cropped?
    !uncropped?
  end

  def crop_ratio
    return unless cropped?
    return if missing_size_information?

    fraction = (croppedWidth.to_d / croppedHeight.to_d).to_r.rationalize(0.05)

    "#{fraction.numerator} x #{fraction.denominator}"
  end

  def missing_size_information?
    # this appears to happen for video files
    croppedWidth.nil? && croppedHeight.nil? && fileHeight.nil? && fileWidth.nil?
  end

  def lens_profile_corrections?
    profileCorrections == 1
  end

  def chromatic_aberration_corrections?
    removeChromaticAberration == 1
  end
end
