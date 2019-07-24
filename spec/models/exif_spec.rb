require 'rails_helper'

RSpec.describe Exif, type: :model do
  before do
    exif
  end

  describe 'scopes' do
    describe 'wildlife' do
      let(:exif) { create(:exif, focalLength: focal_length) }

      context 'when the lens focal length is greater than 300' do
        let(:focal_length) { 400.0 }

        it 'is included in the results' do
          expect(Exif.wildlife).to include exif
        end
      end

      context 'when the lens focal length is 300' do
        let(:focal_length) { 300.0 }

        it 'is included in the results' do
          expect(Exif.wildlife).to include exif
        end
      end

      context 'when the lens focal length is less than 300' do
        let(:focal_length) { 100.0 }

        it 'is not included in the results' do
          expect(Exif.wildlife).not_to include exif
        end
      end
    end

    describe 'wide_angle_landscape' do
      let(:exif) { create(:exif, isoSpeedRating: iso, focalLength: focal_length, cameraModelRef: camera.id) }

      context 'for a Canon dslr' do
        let(:camera) { create(:camera, value: 'Canon EOS 5D Mark IV') }

        context 'when the iso is 100' do
          let(:iso) { 100.0 }

          context 'when the focal length is less than 35mm' do
            let(:focal_length) { 34.0 }

            it 'is included in the results' do
              expect(Exif.wide_angle_landscape).to include exif
            end
          end

          context 'when the focal length is 35mm' do
            let(:focal_length) { 35.0 }

            it 'is included in the results' do
              expect(Exif.wide_angle_landscape).to include exif
            end
          end

          context 'when the focal length is greater than 35mm' do
            let(:focal_length) { 36.0 }

            it 'is not included in the results' do
              expect(Exif.wide_angle_landscape).not_to include exif
            end
          end
        end

        context 'when the iso is not 100' do
          let(:iso) { 200.0 }
          let(:focal_length) { 34.0 }

          it 'is not included in the results' do
            expect(Exif.wide_angle_landscape).not_to include exif
          end
        end
      end

      context 'for a camera that is not a Canon dslr' do
        let(:camera) { create(:camera, value: 'Canon Powershot G12') }
        let(:iso) { 100.0 }
        let(:focal_length) { 34.0 }

        it 'is not included in the results' do
          expect(Exif.wide_angle_landscape).not_to include exif
        end
      end
    end

    describe 'macro' do
      let(:exif) { create(:exif, lensRef: lens.id) }

      context 'for a macro lens' do
        let(:lens) { create(:lens, value: 'EF100mm f/2.8 Macro USM') }

        it 'is included in the results' do
          expect(Exif.macro).to include exif
        end
      end

      context 'for a non-macro lens' do
        let(:lens) { create(:lens, value: 'EF24-105mm f/4 IS USM') }

        it 'is not included in the results' do
          expect(Exif.macro).not_to include exif
        end
      end
    end

    describe 'by_camera' do
      let(:camera_1) { create(:camera) }
      let(:exif) { create(:exif, cameraModelRef: camera_1.id) }

      context 'for a single camera id' do
        context 'when the cameraModelRef matches the value passed in' do
          it 'is included in the results' do
            expect(Exif.by_camera(camera_1.id)).to include exif
          end
        end

        context 'when the cameraModelRef does not match the value passed in' do
          it 'is not included in the results' do
            expect(Exif.by_camera(0)).not_to include exif
          end
        end
      end

      context 'for multiple camera ids' do
        let(:camera_2) { create(:camera) }
        let(:exif_2) { create(:exif, cameraModelRef: camera_2.id) }

        before do
          exif_2
        end

        it 'includes results for all the camera ids' do
          results = Exif.by_camera([camera_1.id, camera_2.id])

          expect(results).to include exif
          expect(results).to include exif_2
        end
      end
    end

    describe 'by_lens' do
      let(:lens_1) { create(:lens) }
      let(:exif) { create(:exif, lensRef: lens_1.id) }

      context 'for a single lens id' do
        context 'when the lensRef matches the value passed in' do
          it 'is included in the results' do
            expect(Exif.by_lens(lens_1.id)).to include exif
          end
        end

        context 'when the lensRef does not match the value passed in' do
          it 'is not included in the results' do
            expect(Exif.by_lens(0)).not_to include exif
          end
        end
      end

      context 'for multiple lens ids' do
        let(:lens_2) { create(:lens) }
        let(:exif_2) { create(:exif, lensRef: lens_2.id) }

        before do
          exif_2
        end

        it 'includes results for all the lens ids' do
          results = Exif.by_lens([lens_1.id, lens_2.id])

          expect(results).to include exif
          expect(results).to include exif_2
        end
      end
    end

    describe 'by_year' do
      let(:exif) { create(:exif, dateYear: 2019.0) }

      context 'for a single year' do
        context 'when the year matches the value passed in' do
          it 'is included in the results' do
            expect(Exif.by_year(2019)).to include exif
          end
        end

        context 'when the year does not match the value passed in' do
          it 'is not included in the results' do
            expect(Exif.by_year(2018)).not_to include exif
          end
        end
      end

      context 'for more than one year' do
        let(:exif_2) { create(:exif, dateYear: 2018.0) }

        before do
          exif_2
        end

        it 'includes results for all the years' do
          results = Exif.by_year([2019, 2018])

          expect(results).to include exif
          expect(results).to include exif_2
        end
      end
    end
  end

  describe '#shutter_speed_value' do
    let(:exif) { create(:exif, shutterSpeed: shutter_speed) }

    context 'when shutterSpeed is present' do
      let(:shutter_speed) { 10.643856 }

      it 'calculates the fractional shutter speed' do
        expect(exif.shutter_speed_value).to eq 1600
      end
    end

    context 'when shutterSpeed is not present' do
      let(:shutter_speed) {}

      it 'returns nil' do
        expect(exif.shutter_speed_value).to eq nil
      end
    end
  end

  describe '#month_and_year' do
    let(:month) {}
    let(:year) {}
    let(:exif) { create(:exif, dateMonth: month, dateYear: year) }

    context 'when dateMonth and dateYear are present' do
      let(:month) { 4.0 }
      let(:year) { 2019.0 }

      it 'calculates the month and year' do
        expect(exif.month_and_year).to eq 'April 2019'
      end
    end

    context 'when only dateMonth is present' do
      let(:month) { 5.0 }

      it 'returns nil' do
        expect(exif.month_and_year).to eq nil
      end
    end

    context 'when only dateYear is present' do
      let(:year) { 2018.0 }

      it 'returns nil' do
        expect(exif.month_and_year).to eq nil
      end
    end

    context 'when neither dateMonth or dateYear are present' do
      it 'returns nil' do
        expect(exif.month_and_year).to eq nil
      end
    end
  end
end
