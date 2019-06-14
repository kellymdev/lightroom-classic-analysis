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

  describe '#by_lens' do
    let(:lens) { create(:lens) }

    before do
      lens
    end

    it 'renders the by_lens template' do
      post :by_lens, params: { lens_name: 'EF24-105mm f/4L IS USM' }

      expect(response).to render_template :by_lens
    end
  end
end
