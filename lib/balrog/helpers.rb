# Helpers methods are made available in all controllers by the code in engine.rb.
module Balrog::Helpers
  def authenticate_with_balrog!
    unless session[:balrog] == 'authenticated'
      view_locals = {
        current_path: request.path
      }
      render 'balrog/gate', layout: nil, locals: view_locals
    end
  end
end
