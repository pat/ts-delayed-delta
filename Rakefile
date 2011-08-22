require 'rubygems'
require 'bundler'

Bundler::GemHelper.install_tasks
Bundler.require :default, :development

require 'rspec/core/rake_task'
require 'cucumber/rake/task'

RSpec::Core::RakeTask.new

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.rcov_opts = ['--exclude', 'spec', '--exclude', 'gems']
  spec.rcov      = true
end

Cucumber::Rake::Task.new do |task|
  task.cucumber_opts = '--exclude features/thinking_sphinx'
end

YARD::Rake::YardocTask.new

task :default => [:spec, :cucumber]
