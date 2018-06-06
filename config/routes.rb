Rails.application.routes.draw do
  namespace :api do
    namespace :v2 do
      resources :missions, only: [:index] do
        get :agregacion, on: :collection
      end
    end
  end
end
