# frozen_string_literal: true

FactoryBot.define do
  factory :develop_setting do
    croppedHeight { nil }
    croppedWidth { 'uncropped' }
    fileHeight { 3456.0 }
    fileWidth { 5184.0 }
    grayscale { 0 }
    hasDevelopAdjustmentsEx { 1.0 }
    image { 1 }
    processVersion { 11.0 }
    profileCorrections { 1.0 }
    removeChromaticAberration { 1 }
    whiteBalance { 'As Shot' }

    factory :cropped_develop_setting do
      croppedHeight { 3295.0 }
      croppedWidth { 4943.0 }
    end
  end
end