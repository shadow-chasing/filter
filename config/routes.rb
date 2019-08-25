Rails.application.routes.draw do

    # filter namespace
    namespace :youtube_filter do

        # root
        root 'subtitles#index'

        # resources
        resources :categories
        resources :subtitles

    end

    # static pages
    get 'pages/results'

end
