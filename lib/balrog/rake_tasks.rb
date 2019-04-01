# This Railtie makes the Balrog Rake tasks available from the command line.
class Balrog::RakeTasks < Rails::Railtie
  rake_tasks do
    load File.join(File.dirname(__FILE__), 'tasks', 'generate_hash.rake')
  end
end
