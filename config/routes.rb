# frozen_string_literal: true

Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
  mount Lookbook::Engine, at: '/lookbook' if Rails.env.development?

  admin_constraint = lambda { |request|
    current_user = request.env['warden'].user
    current_user.present? && current_user.respond_to?(:admin?) && current_user.admin?
  }

  constraints admin_constraint do
    mount Sidekiq::Web => '/admin/sidekiq'
    mount PgHero::Engine => '/admin/pghero'
  end

  devise_for :user, path: '', controllers: { omniauth_callbacks: 'eve_oauth_callbacks' }
  devise_scope :user do
    delete 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  get '/autocompletions/identities', to: 'autocompletions#identities'

  namespace :settings do
    resource :account, controller: 'account', only: %i[show update destroy] do
      get :confirm_destroy
    end

    resources :esi_grants, path: 'esi/grants', only: %i[destroy] do
      get :confirm_approve
      post :approve
      get :confirm_reject
      post :reject
      get :confirm_destroy
    end

    resources :identities, path: 'characters', only: %i[index new create destroy] do
      put :change_default
      get :confirm_destroy
      post :switch
    end

    resources :esi_tokens, path: 'esi', only: %i[index new create show destroy] do
      get :confirm_approve
      post :approve
      get :confirm_reject
      post :reject
      post :authorize, to: 'esi_tokens#authorize_token'
      get :confirm_destroy
    end

    root to: redirect('/settings/account')
  end

  namespace :admin do # rubocop:disable Metrics/BlockLength
    resources :alliances, only: %i[index]

    resources :corporations, only: %i[index]

    resources :characters, only: %i[index]

    resources :esi_grants, path: 'esi/grants', only: %i[index new create destroy]

    resources :esi_tokens, path: 'esi', only: %i[index new create show destroy] do
      get :confirm_destroy
    end

    resources :login_permits, path: 'authentication', only: %i[index new create destroy] do
      get :confirm_destroy
    end

    resources :markets do
      resources :locations, controller: 'market_locations', except: %i[index show edit update] do
        get :confirm_destroy

        collection do
          get :autocomplete_stations
          get :autocomplete_structures
        end
      end

      resources :sources, controller: 'market_sources', except: %i[index show edit update] do
        get :confirm_destroy

        collection do
          get :autocomplete_regions
          get :autocomplete_structures
        end
      end

      get :confirm_destroy
      get :confirm_disable
      get :confirm_enable
      post :disable
      post :enable

      collection do
        get :confirm_disable_all
        post :disable_all
      end
    end

    resources :market_order_sources, path: 'market-sources', except: %i[edit update] do
      get :confirm_destroy
      get :confirm_disable
      get :confirm_enable
      post :disable
      post :enable

      collection do
        get :confirm_disable_all
        post :disable_all
      end
    end

    resources :static_data_versions, path: 'static-data', only: %i[index] do
      collection do
        put :check
      end

      get :confirm_download
      get :confirm_import
      post :download
      post :import
    end

    resources :structures, only: %i[index new create show] do
      post :sync
      get :confirm_market_source
      post :market_source
    end

    resources :users, only: %i[index destroy] do
      get :confirm_destroy
    end

    root to: redirect('/dashboard')
  end

  resources :markets, only: %i[index show]

  namespace :dashboard do
    root to: 'overview#show'
  end

  root 'home#index'
end
