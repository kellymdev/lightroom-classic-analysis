require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  describe '#index' do
    let(:image) { create(:image) }

    before do
      image
    end

    it 'renders the index template' do
      get :index

      expect(response).to render_template :index
    end
  end

  describe '#by_camera' do
    let(:camera) { create(:camera) }

    before do
      camera
    end

    it 'renders the by_camera template' do
      post :by_camera, params: { camera_name: 'Canon EOS 5D Mark IV' }

      expect(response).to render_template :by_camera
    end
  end
end
