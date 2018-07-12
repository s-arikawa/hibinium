require 'rspec'
require 'hibinium/command/model/hibifo_template'
require 'yaml'

RSpec.describe Hibinium::HibifoTemplate do

  it 'default_set' do
    y = Hibinium::HibifoTemplate.default_set
    p y
    puts YAML.dump(y.to_hash)
  end
end