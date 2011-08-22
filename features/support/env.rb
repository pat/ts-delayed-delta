require 'rubygems'
require 'fileutils'
require 'bundler'

Bundler.require :default, :development

require 'active_record'
require 'thinking_sphinx'
require 'delayed_job'

ActiveRecord::Base.send(:include, ThinkingSphinx::ActiveRecord)
Delayed::Worker.backend = :active_record

ActiveSupport::Inflector.inflections do |inflect|
  inflect.plural /^(.*)beta$/i, '\1betas'
  inflect.singular /^(.*)betas$/i, '\1beta'
end

$:.unshift File.dirname(__FILE__) + '/../../lib'

require 'cucumber/thinking_sphinx/internal_world'

# Time.zone_default = Time.__send__(:get_zone, 'Melbourne')
# ActiveRecord::Base.time_zone_aware_attributes = true
# ActiveRecord::Base.default_timezone = :utc
#
world = Cucumber::ThinkingSphinx::InternalWorld.new
world.configure_database

require "thinking_sphinx"
require 'thinking_sphinx/deltas/delayed_delta'

world.setup
