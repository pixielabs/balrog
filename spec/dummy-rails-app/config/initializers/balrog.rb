Balrog::Middleware.setup do |config|
  config.set_password_hash '$2a$10$IZ/Td/JiQknLW19cTyyl5OAYF2Vf.46D2ovZGlQfdUVbHiMk9gvDy'

  credentials = Rails.application.credentials
  config.set_omniauth :google_oauth2, credentials.google_client_id, credentials.google_client_secret
  config.set_domain_whitelist 'pixielabs.io'
end