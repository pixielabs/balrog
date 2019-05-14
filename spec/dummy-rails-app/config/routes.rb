Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  # We tell SideKiq to use Balrog::RoutesMiddleware
  Sidekiq::Web.use Balrog::RoutesMiddleware

  mount Sidekiq::Web => '/sidekiq'

  get '/admin' => 'admin#index'

  root to: 'home#index'
end
