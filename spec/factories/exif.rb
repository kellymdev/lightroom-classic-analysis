# frozen_string_literal: true

FactoryBot.define do
  factory :exif do
    image { 1 }
    aperture { 4.0 }
    cameraModelRef { 1 }
    cameraSNRef { 1 }
    dateDay { 16.0 }
    dateMonth { 2.0 }
    dateYear { 2019.0 }
    flashFired { 0 }
    focalLength { 100.0 }
    isoSpeedRating { 1600.0 }
    lensRef { 1 }
    shutterSpeed { 4.07 }
  end
end
