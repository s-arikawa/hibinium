require 'rspec'
require 'utils/formatter'

RSpec.describe Formatter do

  it 'should do something' do

    s = 'Hello World'

    puts Formatter.arrow(s)
    puts Formatter.headline(s)
    puts Formatter.identifier(s)
    puts Formatter.option(s)
    puts Formatter.success(s)
    puts Formatter.warning(s)
    puts Formatter.error(s)

  end
end