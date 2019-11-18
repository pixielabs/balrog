# Contains authentication logic to check the user has been authenticated,
# and that the session hasn't expired.
module Balrog::Guard
  def authenticated?(balrog_session)
    @balrog_session = balrog_session
    previously_authenticated? && still_valid?
  end

  private

  # A method to check that the user has been authenticated before.
  def previously_authenticated?
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