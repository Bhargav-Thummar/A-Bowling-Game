Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api, path: nil, defaults: { format: 'json' } do
    namespace :v1, defaults: { format: 'json' } do
      resources :games, only: [:index, :create] do
        collection do
          get :get_score_card, to: "games#get_score_card", as: :get_score_card
          post :add_score, to: "games#add_score", as: :games_add_score
        end
      end
    end
  end
end
