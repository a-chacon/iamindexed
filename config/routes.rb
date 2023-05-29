Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get 'search', to: 'home#search'
  post 'check', to: "home#check"
  root to: 'home#index'
end
