require 'rspec'
require 'hibinium/command'
require 'hibinium/command/set'

RSpec.describe Hibinium::Command do

  it 'diff' do
    cmd = Hibinium::Command.new
    cmd.diff
  end
end