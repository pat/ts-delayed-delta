require 'jeweler'
require 'yard'

YARD::Rake::YardocTask.new

Jeweler::Tasks.new do |gem|
  gem.name        = 'ts-delayed-delta'
  gem.summary     = 'Thinking Sphinx - Delayed Deltas'
  gem.description = 'Manage delta indexes via Delayed Job for Thinking Sphinx'
  gem.email       = "pat@freelancing-gods.com"
  gem.homepage    = "http://github.com/freelancing-god/ts-delayed-delta"
  gem.authors     = ["Pat Allan"]
  
  gem.add_dependency 'delayed_job', '>= 1.8.4'
  
  gem.add_development_dependency "rspec",    ">= 1.2.9"
  gem.add_development_dependency "yard",     ">= 0"
  gem.add_development_dependency "cucumber", ">= 0"
end

Jeweler::GemcutterTasks.new
