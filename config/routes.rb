Rails.application.routes.draw do
  root 'shifts#index'
  resources :shifts, except: %i[edit new show]
end
