require 'rspec'
require 'hibinium/command'
require 'hibinium/command/pf'

RSpec.describe Hibinium::Command do

  it 'pf test' do
    cmd = Hibinium::Command.new
    cmd.pf
  end
end