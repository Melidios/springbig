Rails.application.routes.draw do
  root to: 'data_items#input'
  get 'data_items/input', to: 'data_items#input'
  resources :data_items, only: [:create]
  get 'data_items/output', to: 'data_items#output'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
