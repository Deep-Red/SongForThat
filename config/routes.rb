Rails.application.routes.draw do

  devise_for :users
  root to: "dashboard#index"

  get "songs/ng",                   to: "songs#ng"
  get "songs/ng/*angular_route",    to: "songs#ng"

  get "tags/ng",                    to: "tags#ng"
  get "tags/ng/*angular_route",     to: "tags#ng"

  get "taggings/ng",                to: "taggings#ng"
  get "taggings/ng/*angular_route", to: "taggings#ng"

  resources :votes
  resources :songs, only: [ :index, :show ]
  resources :tags, only: [ :index, :show, :new, :create ]
  resources :taggings, only: [ :index, :show, :new, :create ]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
