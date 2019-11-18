require_relative 'guard'

# Helpers methods are made available in all controllers by the code in engine.rb.
module Balrog::Helpers
  include Balrog::Guard

  def authenticate_with_balrog!
    unless authenticated?(session[:balrog])
      view_locals = {
        current_path: request.path
      }
      render 'balrog/gate', layout: 'balrog', locals: view_locals
    end
  end
end
