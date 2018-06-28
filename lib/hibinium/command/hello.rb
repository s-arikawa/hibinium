require 'hibinium'
require 'hibinium/command'

module Hibinium
  class Command < Thor
    desc 'hello', 'say hello!'
    def hello
      puts 'Hello!'
    end
  end
end