$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'rubygems'
require 'spec'
require 'spec/autorun'

require 'thinking_sphinx'
require 'thinking_sphinx/deltas/delayed_delta'

Spec::Runner.configure do |config|
  #
end
