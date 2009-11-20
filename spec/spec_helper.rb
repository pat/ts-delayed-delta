$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'rubygems'
require 'spec'
require 'spec/autorun'

SphinxVersion = ENV['VERSION'] || '0.9.8'

require "thinking_sphinx/#{SphinxVersion}"
require 'thinking_sphinx/deltas/delayed_delta'

Spec::Runner.configure do |config|
  #
end
