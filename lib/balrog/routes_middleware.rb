require 'bcrypt'
require_relative 'helpers'

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

class Balrog::RoutesMiddleware < Balrog::Middleware
  include Balrog::Helpers

  def call(env)
    unless env['rack.session']['balrog'] == 'authenticated'
      referer = env['rack.session']["HTTP_REFERER"] || '/'
      view = File.open('../../app/views/balrog/gate.html.erb', 'r')
      return [200, {"Content-Type" => "text/html"}, [view.read]]  
    end
    super
  end 

end

