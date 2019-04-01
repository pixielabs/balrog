require 'bcrypt'
require 'io/console'

class PasswordHasher
  def self.encrypt_password
    print "Enter New Password: "
    password = STDIN.noecho(&:gets).chomp
    print "\nConfirm New Password: "
    if password == STDIN.noecho(&:gets).chomp then
      password_hash = BCrypt::Password.create(password)
      puts "\n"
      password_hash 
    else 
      puts "\n"
      warn 'Passwords did not match :('
    end
  end
end
