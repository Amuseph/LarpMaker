# frozen_string_literal: true

Rails.application.routes.draw do
  root 'pages#index'
  devise_for :users

  namespace :pages do
    get :setting
    get :calendar
    get :mythology
    get :camp
    get :rulebook
    get :events
    get :community
  end

  namespace :admin do
      resources :settings
      resources :users
      resources :characters
      resources :backstories
      resources :explogs
      resources :banklogs
      resources :events
      resources :guilds
      resources :houses
      resources :eventattendances
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
      resources :worldareas
      
      root to: "settings#index"
    end

  namespace :character do
    get :getcharacter
    get :editbackstory
    post :savebackstory
    get :banklog
    get :events
    get :courier
    get :viewcourier
    get :sendcourier
    post :sendcourier
    get :sendprayer
    post :sendprayer
    get :sendoracle
    post :sendoracle
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
    get :mealplan
    get :castsignup
    post :castsignup
    post :ordermealplan
    post :processmealplanorder
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
