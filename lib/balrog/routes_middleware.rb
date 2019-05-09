require 'bcrypt'

# Public: Balrog middleware that handles form submissions, checking the
# password against the configured hash, and setting a session variable if
# they match.
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
      html = ApplicationController.renderer.render 'balrog/gate', layout: nil
      return [200, {"Content-Type" => "text/html"}, [html]]  
    end
    @app.call(env)
  end 

end

