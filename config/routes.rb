Rails.application.routes.draw do

    # youtube_filter namespace
    namespace :youtube_filter do

        # root
        root 'youtube_filter/subtitles#index'

        # resources
        resources :categories
        resources :subtitles

    end

    # static pages
    get 'pages/results'

end
