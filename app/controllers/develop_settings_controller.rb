# frozen_string_literal: true

class DevelopSettingsController < ApplicationController
  def index
    @develop_data = CalculateDevelopSettingData.new.call
  end
end
