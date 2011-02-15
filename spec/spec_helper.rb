$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'rubygems'
require 'bundler'
 
Bundler.require :default, :development

require 'thinking_sphinx'
require 'thinking_sphinx/deltas/delayed_delta'

Delayed::Worker.backend = :active_record

RSpec.configure do |config|
  #
end
