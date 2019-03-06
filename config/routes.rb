Rails.application.routes.draw do
  resources :links, only: [:index, :create]

  namespace :api do
    namespace :v1 do
      resources :stats, param: :code, only: [:show] do
        member do
          get :viewers
          get :viewers_by_country
          get :viewers_by_browser
        end
      end

      resources :links, param: :code, only: [:create]
    end
  end

  get "/:code" => 'links#visit'
  root :to => 'links#index'

end
