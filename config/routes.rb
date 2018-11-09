Rails.application.routes.draw do
  resources :links, only: [:index, :create] do
    collection do
      get 'visit/:code' => :redirect
    end
  end

  get "/:code" => 'links#visit'
  root :to => 'links#index'

end
