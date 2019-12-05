# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GenresController, type: :controller do
  render_views

  describe '#wildlife_data' do
    it 'renders the wildlife_data template' do
      get :wildlife_data

      expect(response).to render_template :wildlife_data
    end
  end

  describe '#landscape_data' do
    it 'renders the landscape_data template' do
      get :landscape_data

      expect(response).to render_template :landscape_data
    end
  end

  describe '#macro_data' do
    it 'renders the macro_data template' do
      get :macro_data

      expect(response).to render_template :macro_data
    end
  end

  describe '#astro_data' do
    it 'renders the astro_data template' do
      get :astro_data

      expect(response).to render_template :astro_data
    end
  end
end
