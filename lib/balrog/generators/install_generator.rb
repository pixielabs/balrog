require_relative '../password_hasher'
require_relative '../session_length_ui'

class Balrog::InstallGenerator < Rails::Generators::Base

  desc "Creates a balrog initializer and configures it with the provided password (you'll be prompted for it)."
  def create_initializer_file
    password_hash = PasswordHasher.encrypt_password
    contents = <<~EOF
      Rails.application.config.middleware.use Balrog::Middleware do
        password_hash '#{password_hash}'#{SessionLengthUI.set_length}
      end
    EOF
    create_file "config/initializers/balrog.rb", contents
  end
end
