require 'bcrypt'

# Public: Balrog middleware that handles form submissions, checking the
# password against the configured hash, and setting a session variable if
# they match.
#
# This is typically set up in an initialize when you run
# `rails g balrog:install`, and looks a bit like this:
#
#    Rails.application.config.middleware.use Balrog::Middleware do
#      password_hash '<bcrypt hash>'
#    end
class Balrog::Middleware
  def initialize(app, &block)
    @app = app
    instance_eval(&block) if block_given?
  end

  def call(env)
    path = env["PATH_INFO"]
    method = env["REQUEST_METHOD"]
    if method == 'POST' && path == '/balrog/signin'
      handle_login(env)
    else
      @app.call(env)
    end
  end

  private

  def password_hash(input)
    @password_hash = BCrypt::Password.new(input)
  end

  def handle_login(env)
    if env['rack.request.form_hash']
      submitted_password = env['rack.request.form_hash']['password']
    end

    unless submitted_password
      return [302, {"Location" => referer}, [""]]
    end

    unless @password_hash
      warn <<~EOF

        !! Balrog has not been configured with a password_hash. You shall not
        !! pass! When adding Balrog::Middleware to your middleware stack, pass
        !! in a block and call `password_hash` passing in a bcrypt hash.
        !!
        !! Check out https://github.com/pixielabs/balrog for more information.

      EOF
    end

    if @password_hash == submitted_password
      env['rack.session'][:balrog] = 'authenticated'
    end

    referer = env["HTTP_REFERER"] || '/'

    [302, {"Location" => referer}, [""]]
  end

end

