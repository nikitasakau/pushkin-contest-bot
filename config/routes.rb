Rails.application.routes.draw do
  post 'quiz', to: 'quiz#task'
  root 'quiz#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
