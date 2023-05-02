# frozen_string_literal: true

Rails.application.routes.draw do
  root 'pages#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  namespace :pages do
    get :setting
    get :calendar
    get :mythology
    get :races
    get :damarkeep
    get :laws
    get :townpositions
    get :rulebook
    get :craftingguide
    get :rulebookchangelog
    get :camp
    get :events
    get :eventschedule
    get :communitylibrary
    get :larpresources
    get :community
    get :earnxp
    get :waiver
    get :termsofservice
    get :faq
  end

  namespace :admin do
      resources :settings
      resources :users
      resources :characters
      resources :backstories
      resources :explogs
      resources :exploguploads
      resources :banklogs
      resources :bankloguploads
      resources :events
      resources :guilds
      resources :houses
      resources :eventattendances
      resources :eventfeedbacks, only: [:index, :show, :destroy]
      resources :incidents
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
      resources :characterskills
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
    get :xpstore
    post :spendxp
    get :courier
    get :viewcourier
    get :sendcourier
    post :sendcourier
    get :house
    get :guild
    get :sendbetweengame
    post :sendbetweengame
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
    get :printablesheet
    get :rewrite
    post :rewrite
  end

  resources :character
  
  resources :event do
    get :updatecabin
    patch :updatecabin
    get :mealplan
    post :ordermealplan
    post :updatemealplan
    post :preparemealplanorder
    post :processmealplanorder
    get :playersignup
    post :orderevent
    post :prepareeventorder
    post :processeventorder
    get :castsignup
    get :viewfeedback
    get :submitfeedback
    post :submitfeedback
    post :castsignup
    get :playerlist
  end

  namespace :player do
    get :explog
    get :transferxp
    post :transferxp
    get :changecharacter
    post :changecharacter
    get :validateemail
    get :validatexpamount
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
