require 'rails'

module Balrog 
  require_relative 'balrog/version'
  require_relative 'balrog/middleware'
  require_relative 'balrog/routes_middleware'
  require_relative 'balrog/engine'
  require_relative 'balrog/rake_tasks'
  require_relative 'balrog/generators'
end 
