require 'bcrypt'

# Public: Balrog middleware that handles form submissions, checking the
# password against the configured hash, and setting a session variable if
# they match.
#
# This is typically set up in an initialize when you run
# `rails g balrog:install`, and looks a bit like this:
#
#  Balrog::Middleware.setup do |config|
#    config.set_password_hash '$2a$10$IZ/Td/JiQknLW19cTyyl5OAYF2Vf.46D2ovZGlQfdUVbHiMk9gvDy'
#    config.set_omniauth :google_oauth2, Rails.application.credentials.provider_key, Rails.application.credentials.provider_secret_key
#  end

class Balrog::Middleware

  mattr_reader :omniauth_config
  mattr_reader :password_hash
  mattr_reader :domain_whitelist

  def initialize(app)
    @app = app
  end

  def call(env)
    path = env["PATH_INFO"]
    method = env["REQUEST_METHOD"]
    if login_request?(path, method)
      handle_login(env)
    elsif omniauth_request?(path, method)
      handle_omniauthentication(env)
    elsif logout_request?(path, method)
      handle_logout(env)
    else
      @app.call(env)
    end
  end

  def self.setup
    yield self
  end

  private

  def self.set_password_hash(input)
    @@password_hash = BCrypt::Password.new(input)
  end

  def self.set_omniauth(provider, *args)
    @@omniauth_config = {
      provider: provider,
      args: args
    }
  end

  def self.set_domain_whitelist(*domains)
    @@domain_whitelist = domains
  end

  def handle_login(env)
    if env['rack.request.form_hash']
      submitted_password = env['rack.request.form_hash']['password']
    end

    unless submitted_password
      return [302, {"Location" => referer}, [""]]
    end

    unless password_hash
      warn <<~EOF

        !! Balrog has not been configured with a password_hash. You shall not
        !! pass! When adding Balrog::Middleware to your middleware stack, pass
        !! in a block and call `password_hash` passing in a bcrypt hash.
        !!
        !! Check out https://github.com/pixielabs/balrog for more information.

      EOF
    end

    if password_hash == submitted_password
      env['rack.session'][:balrog] = 'authenticated'
    end

    referer = env["HTTP_REFERER"] || '/'

    [302, {"Location" => referer}, [""]]
  end

  def handle_omniauthentication(env)
    if env['omniauth.auth']['info']['email']
      user_email = env['omniauth.auth']['info']['email']
      email_domain = user_email.split("@").last
    end

    unless email_domain
      return [302, {"Location" => referer}, [""]]
    end

    unless domain_whitelist
      warn <<~EOF

        !! Balrog has not been configured with a domain_whitelist. You shall not
        !! pass! When setting up Balrog::Middleware, pass in a block and
        !! call `set_domain_whitelist` passing in an omniauth provider and
        !! required keys.
        !!
        !! Check out https://github.com/pixielabs/balrog for more information.

      EOF
    end

    if domain_whitelist && domain_whitelist.include?(email_domain)
      env['rack.session'][:balrog] = 'authenticated'
    end

    referer = env["omniauth.origin"] || '/'

    [302, {"Location" => referer}, [""]]
  end

  def handle_logout(env)
    env['rack.session'].delete(:balrog)
    [302, {"Location" => '/'}, [""]]
  end

  def login_request?(path, method)
    method == 'POST' && path == '/balrog/signin'
  end

  def omniauth_request?(path, method)
    omniauth_config &&
      method == "GET" &&
      path == "/auth/#{omniauth_config[:provider]}/callback"
  end

  def logout_request?(path, method)
    method == "DELETE" && path == '/balrog/logout'
  end

end

