Rails.application.routes.draw do

  devise_for :users
  root to: "dashboard#index"

  get "songs/ng",                   to: "songs#ng"
  get "songs/ng/*angular_route",    to: "songs#ng"

  resources :songs, only: [ :index, :show ]
  resources :tags
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
