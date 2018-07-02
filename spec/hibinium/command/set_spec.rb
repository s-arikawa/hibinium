require 'rspec'
require 'hibinium/command'
require 'hibinium/command/set'

RSpec.describe Hibinium::Command do

  it 'set' do
    set = Hibinium::Command.new
    set.set
  end
end