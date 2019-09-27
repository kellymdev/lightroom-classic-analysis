# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  render_views

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
      post :by_camera, params: { camera_name: 'Canon EOS 5D Mark IV', year: '2019' }

      expect(response).to render_template :by_camera
    end
  end

  describe '#by_lens' do
    let(:lens) { create(:lens) }

    before do
      lens
    end

    it 'renders the by_lens template' do
      post :by_lens, params: { lens_name: 'EF24-105mm f/4L IS USM', year: '2019' }

      expect(response).to render_template :by_lens
    end
  end

  describe '#by_camera_and_lens' do
    let(:camera) { create(:camera) }
    let(:lens) { create(:lens) }

    before do
      camera
      lens
    end

    it 'renders the by_camera_and_lens template' do
      post :by_camera_and_lens, params: { camera_name: 'Canon EOS 5D Mark IV', lens_name: 'EF24-105mm f/4L IS USM', year: '2019' }
    end
  end
end
