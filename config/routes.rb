Rails.application.routes.draw do

  root to: "dashboard#index"
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks"}

  get "songs/ng",                   to: "songs#ng"
  get "songs/ng/*angular_route",    to: "songs#ng"

  get "tags/ng",                    to: "tags#ng"
  get "tags/ng/*angular_route",     to: "tags#ng"

  get "taggings/ng",                to: "taggings#ng"
  get "taggings/ng/*angular_route", to: "taggings#ng"

  post "votes/upvote",              to: "votes#upvote"
  post "votes/downvote",            to: "votes#downvote"

  resources :songs, only: [ :index, :show ]
  resources :tags, only: [ :index, :show, :new, :create ]
  resources :taggings, only: [ :index, :show, :new, :create ]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
