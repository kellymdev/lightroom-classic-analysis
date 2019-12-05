Rails.application.routes.draw do
  root to: 'dashboard#index'

  get '/dashboard', to: 'dashboard#index'

  get '/wildlife_data', to: 'genres#wildlife_data', as: 'wildlife_data'
  get '/landscape_data', to: 'genres#landscape_data', as: 'landscape_data'
  get '/macro_data', to: 'genres#macro_data', as: 'macro_data'
  get '/astro_data', to: 'genres#astro_data', as: 'astro_data'

  get '/capture_time_data', to: 'images#capture_time_data', as: 'capture_time_data'
  get '/keyword_data', to: 'images#keyword_data', as: 'keyword_data'
  get '/ratings_data', to: 'images#ratings_data', as: 'ratings_data'

  get '/health_check_data', to: 'health_checks#index', as: 'health_check_data'

  get '/develop_settings_data', to: 'develop_settings#index', as: 'develop_settings_data'

  get '/collections_data', to: 'collections#index', as: 'collections_data'

  get '/equipment_form', to: 'equipment#index', as: 'equipment_form'
  post '/by_camera', to: 'equipment#by_camera', as: 'by_camera'
  post '/by_lens', to: 'equipment#by_lens', as: 'by_lens'
  post '/by_camera_and_lens', to: 'equipment#by_camera_and_lens', as: 'by_camera_and_lens'
end
