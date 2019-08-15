Rails.application.routes.draw do

    # root
    root 'subtitles#index'

    # resources
    resources :categories
    resources :subtitles

    # static pages
    get 'pages/results'

end
