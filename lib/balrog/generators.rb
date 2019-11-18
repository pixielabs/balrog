# This Railtie makes the Balrog Generators available from the command line.
class Balrog::Generators < Rails::Railtie
  generators do
    Dir[File.join(__dir__, 'generators', '*.rb')].each { |file| require file }
  end
end
