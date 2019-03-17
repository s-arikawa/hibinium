require 'rspec'
require 'hibinium/command'
require 'hibinium/command/set'

RSpec.describe Hibinium::Command do

  it 'cp' do
    cmd = Hibinium::Command.new
    cmd.cp
  end
end