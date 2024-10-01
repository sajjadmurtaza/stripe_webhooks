Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  namespace :webhooks do
    post 'stripe/create'
  end
end
