# frozen_string_literal: true

Rails.application.routes.draw do
  root 'pages#index'
  devise_for :users

  namespace :pages do
    get :setting
    get :calendar
    get :mythology
    get :laws
    get :camp
    get :rulebook
    get :rulebookchangelog
    get :events
    get :community
    get :earnexp
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
      resources :eventfeedbacks, only: [:index, :show, :destroy]
      resources :cabins
      resources :rulebookchanges
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
    post :ordermealplan
    post :preparemealplanorder
    post :processmealplanorder
    get :playersignup
    post :orderevent
    post :processeventorder
    get :castsignup
    get :viewfeedback
    get :submitfeedback
    post :submitfeedback
    post :castsignup
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
