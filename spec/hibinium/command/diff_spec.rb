require 'rspec'
require 'hibinium/command'
require 'hibinium/command/set'

RSpec.describe Hibinium::Command do

  it 'diff' do
    cmd = Hibinium::Command.new
    cmd.diff
  end

  it 'diff_2018_06' do
    cmd = Hibinium::Command.new
    cmd.diff(2018, 06)
  end
end