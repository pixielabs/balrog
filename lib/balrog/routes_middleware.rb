# Public: Balrog routes middleware that redirects the user to a security
# gate unless the session includes { 'balrog' => 'authenticated' }.
# 
# In order to protect SideKiq Web you would do something like this: 
#
# require 'sidekiq/web'
#
# Sidekiq::Web.disable(:sessions)
# Sidekiq::Web.use Balrog::RoutesMiddleware
#
# mount Sidekiq::Web => '/sidekiq'

class Balrog::RoutesMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    unless env['rack.session']['balrog'] == 'authenticated'
      html = ApplicationController.renderer.render 'balrog/gate', layout: 'balrog'
      return [200, {"Content-Type" => "text/html"}, [html]]  
    end
    @app.call(env)
  end 

end

