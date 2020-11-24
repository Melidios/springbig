Rails.application.routes.draw do
  root 'data_items#index'
  post 'input', to: 'data_items#input'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
