Rails.application.config.middleware.use Balrog::Middleware do
  password_hash '$2a$12$BLz7XCFdG9YfwL64KlTgY.T3FY55aQk8SZEzHfpHfw15F2uN1kuSi'
  session_expires_after 4.hours
end
