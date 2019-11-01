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
    @balrog_session = env['rack.session']['balrog']
    unless authenticated? && still_valid?
      html = ApplicationController.renderer.render 'balrog/gate', layout: nil
      return [200, {"Content-Type" => "text/html"}, [html]]  
    end
    @app.call(env)
  end 

  private

  # A method to check that the user has been authenticated.
  def authenticated?
    return false unless @balrog_session
    @balrog_session['value'] == 'authenticated'
  end

  # A method to check that the authentication has not expired.
  def still_valid?
    # If the user did not set configured the Balrog session 
    # to expire, the cookie is valid.
    return true unless @balrog_session['expiry_date']
    DateTime.current < @balrog_session['expiry_date']
  end

end

