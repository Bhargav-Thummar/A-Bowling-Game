Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api, path: nil, defaults: { format: 'json' } do
    namespace :v1, defaults: { format: 'json' } do
      resources :games, only: [:index, :create]

      post :add_score, to: "games#add_score", as: :games_add_score, path: '/games/add_score'
    end
  end
end
