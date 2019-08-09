Rails.application.routes.draw do
  get 'pages/results'
  resources :categories
    root 'subtitles#index'
  resources :subtitles
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
