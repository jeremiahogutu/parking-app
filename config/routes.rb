Rails.application.routes.draw do

  resources :parkings
  root to: 'parkings#index'
  get 'parkings/pay-ticket/:id' => 'parkings#pay_ticket', :as => 'pay_ticket'
  # post 'parkings/pay-ticket/:id' => 'parkings#pay_ticket', :as => 'pay_ticket'
end
