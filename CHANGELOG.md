# 2.0.0

- Enhancements
  - added support for single sign-on.

- BREAKING
  - Balrog can no longer be initialized via `Rails.application.config.middleware.use Balrog::Middleware`. Instead, you need to configure Balrog with `Balrog::Middleware.setup`. See the [README](https://github.com/pixielabs/balrog#Upgrading-from-1.1-to-2.0) for more info.
  - The instance method `Balrog::Middleware#password_hash` has been converted into a class method `Balrog::Middleware.set_password_hash`. See the [README](https://github.com/pixielabs/balrog#Upgrading-from-1.1-to-2.0) for more info.
  - The instance method `Balrog::Middleware#set_session_expiry` has been converted into a class method `Balrog::Middleware.set_session_expiry`. See the [README](https://github.com/pixielabs/balrog#Upgrading-from-1.1-to-2.0) for more info.

# 1.1.0

- added `Balrog::Middleware#set_session_expiry`, which would force end users to login again after a certain period of time.
- added `balrog:view` generator, enabling users to modify their Balrog gate view.

# 1.0.0

- added `Balrog::RoutesMiddleware` module, which can be used to protect mounted Rack applications.
- dropped support for Rails < 5.

# 0.2.0

- added `balrog_logout_button` view helper method.

# 0.1.0

- initial release.