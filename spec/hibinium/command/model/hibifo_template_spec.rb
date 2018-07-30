require 'rspec'
require 'hibinium/command/model/hibifo_template'
require 'hibinium/my_logger'
require 'yaml'

RSpec.describe Hibinium::HibifoTemplate do
  include Hibinium::MyLogger

  it 'default_set' do
    y = Hibinium::HibifoTemplate.default_set
    p y
    log.info(YAML.dump(y.to_hash))
  end
end