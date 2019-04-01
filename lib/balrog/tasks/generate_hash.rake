require_relative '../password_hasher'

desc 'Prompts for a password, and returns a bcrypt hash that can be passed to password_hash when configuring Balrog'
task "balrog:generate_hash" do
  puts PasswordHasher.encrypt_password
end
