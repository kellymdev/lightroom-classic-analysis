# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImagesController, type: :controller do
  render_views

  describe '#capture_time_data' do
    it 'renders the capture_time_data template' do
      get :capture_time_data

      expect(response).to render_template :capture_time_data
    end
  end

  describe '#keyword_data' do
    it 'renders the keyword_data template' do
      get :keyword_data

      expect(response).to render_template :keyword_data
    end
  end

  describe '#ratings_data' do
    it 'renders the ratings_data template' do
      get :ratings_data

      expect(response).to render_template :ratings_data
    end
  end
end
