# frozen_string_literal: true

class HealthChecksController < ApplicationController
  def index
    @ratings_data = CalculateRatingsData.new(Image.all).call
    @health_check_data = CalculateHealthCheckData.new.call
  end
end
