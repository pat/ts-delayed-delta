require 'rubygems'
require 'cucumber'
require 'spec/expectations'
require 'fileutils'
require 'active_record'

$:.unshift File.dirname(__FILE__) + '/../../lib'

require 'cucumber/thinking_sphinx/internal_world'

world = Cucumber::ThinkingSphinx::InternalWorld.new
world.configure_database

require "thinking_sphinx"
require 'thinking_sphinx/deltas/delayed_delta'

world.setup
