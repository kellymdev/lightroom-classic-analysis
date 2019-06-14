require 'rails_helper'

RSpec.describe CameraHelper, type: :helper do
  describe '.cameras_for_select' do
    let(:camera_1) { create(:camera, value: 'Canon EOS 6D') }
    let(:camera_2) { create(:camera, value: 'Canon EOS 5D Mark IV') }

    before do
      camera_1
      camera_2
    end

    it 'returns a list of camera names in alphabetical order' do
      expect(helper.cameras_for_select).to eq [['Canon EOS 5D Mark IV', 'Canon EOS 5D Mark IV'], ['Canon EOS 6D', 'Canon EOS 6D']]
    end

    context 'when there is more than one camera with the same name' do
      let(:camera_3) { create(:camera, value: 'Canon EOS 6D') }

      before do
        camera_3
      end

      it 'returns a list of uniq camera names' do
        expect(helper.cameras_for_select).to eq [['Canon EOS 5D Mark IV', 'Canon EOS 5D Mark IV'], ['Canon EOS 6D', 'Canon EOS 6D']]
      end
    end
  end
end
