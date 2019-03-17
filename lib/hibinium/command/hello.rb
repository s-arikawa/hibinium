require 'hibinium'
require 'hibinium/command'

module Hibinium
  class Command < Thor
    desc 'hello', 'say hello!'
    def hello(name = "")
      puts "Hello! #{name}"
    end
  end
end