require 'hibinium'
require 'hibinium/command'
require 'hibinium/my_logger'

module Hibinium
  class Command < Thor
    desc 'hello', 'say hello!'
    def hello(name = "")
      log.info( "Hello! #{name}")
    end
  end
end