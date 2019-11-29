# Methods that are called in response to specific application requests.
class Balrog::Middleware
  module Controller

    # This method is called if a user attempts to sign in with a password
    # and will authenticate the user if the password is correct.
    def password_login(env)
      # Extract the submitted_password from the rack request hash.
      if env['rack.request.form_hash']
        submitted_password = env['rack.request.form_hash']['password']
      end

      # If there is no submitted_password, redirect the user before authentication.
      unless submitted_password
        return [302, {"Location" => referer}, [""]]
      end

      # If there is no password_hash, alert the developer.
      unless password_hash
        warn <<~EOF

          !! Balrog has not been configured with a password_hash. You shall not
          !! pass! When adding Balrog::Middleware to your middleware stack, pass
          !! in a block and call `password_hash` passing in a bcrypt hash.
          !!
          !! Check out https://github.com/pixielabs/balrog for more information.

        EOF
      end

      # Authenticate the user if the submitted_password matches the password_hash.
      if password_hash == submitted_password
        authenticate_user(env)
      end

      referer = env["HTTP_REFERER"] || '/'

      [302, {"Location" => referer}, [""]]
    end


    # This method is called if a user attempts to sign in with Single Sign-on
    # and will authenticate the user if email domain has been whitelisted.
    def omniauthentication(env)
      # Extract the email domain from the omniauth hash.
      if env['omniauth.auth']['info']['email']
        user_email = env['omniauth.auth']['info']['email']
        email_domain = user_email.split("@").last
      end
      
      # If there is no email domain, redirect the user before authentication.
      unless email_domain
        return [302, {"Location" => referer}, [""]]
      end

      # If there is no domain_whitelist, alert the developer.
      unless domain_whitelist
        warn <<~EOF

          !! Balrog has not been configured with a domain_whitelist. You shall not
          !! pass! When setting up Balrog::Middleware, pass in a block and
          !! call `set_domain_whitelist` passing in an omniauth provider and
          !! required keys.
          !!
          !! Check out https://github.com/pixielabs/balrog for more information.

        EOF
        return [302, {"Location" => referer}, [""]]
      end

      # Authenticate the user if the user's email domain is whitelisted.
      if domain_whitelist.include?(email_domain)
        authenticate_user(env)
      end

      referer = env["omniauth.origin"] || '/'

      [302, {"Location" => referer}, [""]]
    end


    # This method is called if a user logs out using a balrog logout button.
    # It will achieve this by removing all balrog data from the session.
    def logout(env)
      env['rack.session'].delete(:balrog)
      [302, {"Location" => '/'}, [""]]
    end

    private

    # This method marks the user as 'authenicated'.
    def authenticate_user(env)
      session_data = { value: 'authenticated' }
      add_expiry_date!(session_data)
      env['rack.session'][:balrog] = session_data
    end

    # If the user configured the Balrog session to expire, add the 
    # expiry_date to the Balrog session.
    def add_expiry_date!(session_data)
      if session_length
        session_data[:expiry_date] = DateTime.current + session_length
      end
    end
  end
end