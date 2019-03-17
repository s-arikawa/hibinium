require 'rspec'
require 'hibinium/command'
require 'hibinium/command/rm'

RSpec.describe Hibinium::Command do

  it 'rm' do
    cmd = Hibinium::Command.new
    cmd.rm
  end
end