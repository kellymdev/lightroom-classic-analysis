Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'dashboard#index'

  get '/dashboard', to: 'dashboard#index'
  post '/by_camera', to: 'dashboard#by_camera', as: 'by_camera'
  post '/by_lens', to: 'dashboard#by_lens', as: 'by_lens'
end
