# frozen_string_literal: true

Rails.application.routes.draw do
  root 'pages#index'
  devise_for :users

  namespace :admin do
      resources :settings
      resources :users
      resources :characters
      resources :events
      resources :guilds
      resources :houses
      resources :eventattendances
      resources :explogs
      resources :cabins
      resources :races
      resources :deities
      resources :characterclasses
      resources :skills
      resources :skilldeliveries
      resources :skillgroups
      resources :resttypes
      resources :skillrequirements
      resources :characterclassskillgroups, except: :index
      resources :characterprofessions
      resources :characterskills, except: :index
      resources :couriers
      resources :professions
      resources :professiongroups
      resources :professionrequirements
      
      root to: "settings#index"
    end

  namespace :character do
    get :getcharacter
    get :events
    get :courier
    get :viewcourier
    get :sendprayer
    post :sendprayer
    get :sendcourier
    post :sendcourier
    post :levelup
    get :availableskills
    get :trainskill
    post :trainskill
    get :changephoto
    post :changephoto
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
