Rails.application.routes.draw do

  resources :parkings
  root to: 'parkings#index'
end
