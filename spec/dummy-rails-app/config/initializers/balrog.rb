Balrog::Middleware.setup do |config|
  config.set_password_hash '$2a$12$9lquJW6mVYYS1pD1xYMGzulyC6sEDuLIUfkA/Y7F3RQ8psLNYyLeO'
  config.set_session_expiry 30.minutes

  credentials = Rails.application.credentials
  config.set_omniauth :google_oauth2, credentials.google_client_id, credentials.google_client_secret
  config.set_domain_whitelist 'pixielabs.io'
end
