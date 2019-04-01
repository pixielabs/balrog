# This Railtie makes the Balrog Generators available from the command line.
class Balrog::Generators < Rails::Railtie
  generators do
    require File.join(File.dirname(__FILE__), 'generators', 'install_generator')
  end
end
