# frozen_string_literal: true

Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
  mount Lookbook::Engine, at: '/lookbook' if Rails.env.development?

  admin_constraint = lambda { |request|
    current_user = request.env['warden'].user
    current_user.present? && current_user.respond_to?(:admin?) && current_user.admin?
  }

  constraints admin_constraint do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  devise_for :user, path: '', controllers: { omniauth_callbacks: 'eve_oauth_callbacks' }
  devise_scope :user do
    delete 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  namespace :settings do
    resource :account, controller: 'account', only: %i[show update destroy] do
      get :confirm_destroy
    end

    resources :identities, path: 'characters', only: %i[index new create destroy] do
      put :change_default
      get :confirm_destroy
      post :switch
    end

    root to: redirect('/settings/account')
  end

  namespace :admin do
    resources :alliances, only: %i[index]

    resources :corporations, only: %i[index]

    resources :characters, only: %i[index]

    resources :login_permits, path: 'authentication', only: %i[index new create destroy] do
      get :confirm_destroy
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

    resources :users, only: %i[index destroy] do
      get :confirm_destroy
    end

    root to: redirect('/dashboard')
  end

  namespace :dashboard do
    root to: 'overview#show'
  end

  root 'home#index'
end
