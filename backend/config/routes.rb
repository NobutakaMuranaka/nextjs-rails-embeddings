Rails.application.routes.draw do
  resources :documents, only: [:index, :create]
  post 'documents/search', to: 'documents#search'

  resources :questions, only: [:index, :create, :show]
end
