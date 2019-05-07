Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'

  # In order to force sidekiq to use the rails app's session,
  # we need to disable the Sidekiq's session.
  Sidekiq::Web.disable(:sessions)

  # Then we tell SideKiq to use Balrog::RoutesMiddleware
  Sidekiq::Web.use Balrog::RoutesMiddleware

  mount Sidekiq::Web => '/sidekiq'

  get '/admin' => 'admin#index'

  root to: 'home#index'
end
