require 'rails_helper'

RSpec.describe Camera, type: :model do
  context 'scopes' do
    describe 'for_model_name' do
      let(:model_name) { 'Canon EOS 5D Mark IV' }

      let(:camera_1) { create(:camera, value: model_name) }
      let(:camera_2) { create(:camera, value: 'Canon EOS 6D') }
      let(:camera_3) { create(:camera, value: model_name) }

      before do
        camera_1
        camera_2
        camera_3
      end

      it 'includes all cameras for that model name' do
        results = Camera.for_model_name(model_name)

        expect(results).to include camera_1
        expect(results).to include camera_3
      end

      it 'does not include cameras with a different model name' do
        expect(Camera.for_model_name(model_name)).not_to include camera_2
      end
    end
  end
end
