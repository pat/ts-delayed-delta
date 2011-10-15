# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'thinking_sphinx/deltas/delayed_delta/version'

Gem::Specification.new do |s|
  s.name        = 'ts-delayed-delta'
  s.version     = ThinkingSphinx::DelayedDelta::Version
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Pat Allan']
  s.email       = ['pat@freelancing-gods.com']
  s.homepage    = 'http://github.com/freelancing-god/ts-delayed-delta'
  s.summary     = %q{Thinking Sphinx - Delayed Deltas}
  s.description = %q{Manage delta indexes via Delayed Job for Thinking Sphinx}

  s.rubyforge_project = 'ts-delayed-delta'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'thinking-sphinx', '>= 1.3.6'
  s.add_runtime_dependency 'delayed_job',     '>= 2.0.4'

  s.add_development_dependency 'mysql2',   '0.3.7'
  s.add_development_dependency 'yard',     '>= 0.7.2'
  s.add_development_dependency 'rake',     '>= 0.9.2'
  s.add_development_dependency 'rspec',    '2.6.0'
  s.add_development_dependency 'cucumber', '1.0.2'
end
