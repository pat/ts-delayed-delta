require 'rspec/core/rake_task'
require 'cucumber/rake/task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov    = true
  spec.rcov_opts = [
    '--exclude spec',
    '--exclude gems'
  ]
end

Cucumber::Rake::Task.new do |task|
  task.cucumber_opts = '--exclude features/thinking_sphinx'
end
