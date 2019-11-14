# Helpers methods are made available in all controllers by the code in engine.rb.
module Balrog::Helpers
  def authenticate_with_balrog!
    unless session[:balrog] == 'authenticated'
      render 'balrog/gate', layout: 'balrog'
    end
  end
end
