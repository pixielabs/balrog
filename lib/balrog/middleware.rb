require 'bcrypt'
require_relative 'middleware/controller'

# Public: Balrog middleware that handles form submissions, checking the
# password against the configured hash, and setting a session variable if
# they match.
#
# This is typically set up in an initialize when you run
# `rails g balrog:install`, and looks a bit like this:
#
#  Balrog::Middleware.setup do |config|
#    config.set_password_hash '<bcrypt hash>'
#  end

class Balrog::Middleware
  include Controller

  mattr_reader :password_hash
  mattr_reader :session_length
  mattr_reader :omniauth_config
  mattr_reader :domain_whitelist

  def initialize(app)
    @app = app
  end

  def call(env)
    path = env["PATH_INFO"]
    method = env["REQUEST_METHOD"]
    if login_request?(path, method)
      password_login(env)
    elsif omniauth_request?(path, method)
      omniauthentication(env)
    elsif logout_request?(path, method)
      logout(env)
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

  def self.set_session_expiry(time_period)
    @@session_length = time_period
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

