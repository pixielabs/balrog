require_relative 'guard'

# Helpers methods are made available in all controllers by the code in engine.rb.
module Balrog::Helpers
  include Balrog::Guard

  def authenticate_with_balrog!
    unless authenticated?(session[:balrog])
      render 'balrog/gate', layout: 'balrog'
    end
  end
end
