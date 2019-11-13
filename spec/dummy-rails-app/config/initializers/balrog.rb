Rails.application.config.middleware.use Balrog::Middleware do
  password_hash '$2a$12$I8Fp3e2GfSdM7KFyoMx56.BVdHeeyk9DQWKkdsxw7USvU/mC8a8.q'
  set_session_expiry 30.minutes
end
