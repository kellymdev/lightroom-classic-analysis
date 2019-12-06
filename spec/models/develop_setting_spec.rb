# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DevelopSetting, type: :model do
  describe 'scopes' do
    describe '.cropped' do
      context 'when the image has been cropped' do
        let(:develop_setting) { create(:cropped_develop_setting) }

        before do
          develop_setting
        end

        it 'is included in the results' do
          expect(DevelopSetting.cropped).to include develop_setting
        end
      end

      context 'when the image has not been cropped' do
        let(:develop_setting) { create(:develop_setting) }

        before do
          develop_setting
        end

        it 'is not included in the results' do
          expect(DevelopSetting.cropped).not_to include develop_setting
        end
      end
    end
  end

  describe '#uncropped?' do
    context 'when the image has not been cropped' do
      let(:develop_setting) { create(:develop_setting) }

      it 'is true' do
        expect(develop_setting.uncropped?).to eq true
      end
    end

    context 'when the image has been cropped' do
      let(:develop_setting) { create(:cropped_develop_setting) }

      it 'is false' do
        expect(develop_setting.uncropped?).to eq false
      end
    end
  end

  describe '#cropped?' do
    context 'when the image has been cropped' do
      let(:develop_setting) { create(:cropped_develop_setting) }

      it 'is true' do
        expect(develop_setting.cropped?).to eq true
      end
    end

    context 'when the image has not been cropped' do
      let(:develop_setting) { create(:develop_setting) }

      it 'is false' do
        expect(develop_setting.cropped?).to eq false
      end
    end
  end

  describe '#crop_ratio' do
    context 'when the image has been cropped' do
      let(:develop_setting) { create(:cropped_develop_setting) }

      it 'is the crop ratio of the image' do
        expect(develop_setting.crop_ratio).to eq '3 x 2'
      end
    end

    context 'when the image has not been cropped' do
      let(:develop_setting) { create(:develop_setting) }

      it 'is nil' do
        expect(develop_setting.crop_ratio).to eq nil
      end
    end

    context 'when the image has no crop information' do
      let(:develop_setting) { create(:develop_setting, croppedWidth: nil) }

      it 'is nil' do
        expect(develop_setting.crop_ratio).to eq nil
      end
    end
  end

  describe '#missing_size_information?' do
    context 'when the image has no crop information' do
      let(:develop_setting) { create(:develop_setting, croppedWidth: nil) }

      it 'is true' do
        expect(develop_setting.missing_size_information?).to eq true
      end
    end

    context 'when the image has not been cropped' do
      let(:develop_setting) { create(:develop_setting) }

      it 'is false' do
        expect(develop_setting.missing_size_information?).to eq false
      end
    end

    context 'when the image has been cropped' do
      let(:develop_setting) { create(:cropped_develop_setting) }

      it 'is false' do
        expect(develop_setting.missing_size_information?).to eq false
      end
    end
  end
end
