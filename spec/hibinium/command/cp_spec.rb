require 'rspec'
require 'hibinium/command'
require 'hibinium/command/set'

RSpec.describe Hibinium::Command do

  it 'cp' do
    cmd = Hibinium::Command.new
    cmd.cp
  end

  it 'cp -w' do
    cmd         = Hibinium::Command.new
    cmd.options = { week_of_the_day: true }
    cmd.cp
  end
end