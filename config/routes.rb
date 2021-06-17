# frozen_string_literal: true

Rails.application.routes.draw do
  root 'pages#index'
  devise_for :users

  namespace :character do
    get :getcharacter
    get :events
    get :courier
    get :viewcourier
    get :sendcourier
    post :sendcourier
    post :levelup
    get :availableskills
    get :trainskill
    post :trainskill
    post :removeskill
    get :learnprofession
    post :learnprofession
    post :removeprofession
    get :comingsoon
  end

  resources :character
  
  resources :event do
    get :updatecabin
    patch :updatecabin
  end

  namespace :player do
    get :explog
    get :events
    post :changecharacter
    get :changeeventcharacter
    post :changeeventcharacter
  end

  resources :characterclass do
    get :getcharacterclass
  end
  resources :deity do
    get :getdeity
  end
  resources :race do
    get :getrace
  end
  resources :skill do
    get :getskill
  end
  resources :profession do
    get :getprofession
  end
end
