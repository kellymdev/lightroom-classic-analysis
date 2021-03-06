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
end
