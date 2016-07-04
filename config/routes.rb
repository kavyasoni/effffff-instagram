require 'sidekiq/web'


Rails.application.routes.draw do
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == 'pawel' && password == 'sidekiq protection 57&'
  end if Rails.env.production?

  mount Sidekiq::Web, at: "/sidekiq"

  root 'home#intro'

  resources :batches, only: [:index]

  # Sessions
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'
  delete "/users/sign_out" => "sessions#destroy", as: :destroy_session

  # Profile and searches
  get 'new-search' => 'queries#new', as: :new_query
  get 'hashtag-query' => 'queries#search'
  get 'query-being-processed' => 'queries#waiting', as: :query_waiting
  get 'my-search-history' => 'profile#searches', as: :search_history
  get 'profile/email-saved' => 'profile#thanks', as: :thanks_for_email

  # Onboarding
  get 'welcome/onboarding-guide' => 'onboarding#intro', as: :new_user_tutorial
  post 'welcome/complete-intro' => 'onboarding#complete_intro', as: :complete_intro

  # Profile management
  get 'profile' => 'profile#edit', as: :profile
  patch 'profile' => 'profile#update', as: :update_profile
  patch 'profile-update' => 'profile#update_email_prefs', as: :update_email_prefs

  # Results page
  get 'query/:id/results' => 'results#show', as: :results

  # FAQ page
  get 'help' => 'faq#faq', as: :faq
  get 'privacy-policy' => 'faq#privacy', as: :privacy
  get 'terms' => 'faq#terms', as: :terms

  # Admin
  get 'stats' => 'stats#index', as: :stats
end