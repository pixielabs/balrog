# Helpers methods are made available in all controllers by the code in engine.rb.
module Balrog::Helpers
  def authenticate_with_balrog!
    unless authenticated? && still_valid?
      render 'balrog/gate', layout: nil
    end
  end

  private

  # A method to check that the user has been authenticated.
  def authenticated?
    return false unless session[:balrog]
    session[:balrog]['value'] == 'authenticated'
  end

  # A method to check that the authentication has not expired.
  def still_valid?
    # If the user did not set configured the Balrog session 
    # to expire, the cookie is valid.
    return true unless session[:balrog]['expiry_date']
    DateTime.current < session[:balrog]['expiry_date']
  end
end
