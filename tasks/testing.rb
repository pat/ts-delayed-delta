require 'spec/rake/spectask'
require 'cucumber/rake/task'

Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs      << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs   << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov    = true
end

Cucumber::Rake::Task.new

task :spec      => :check_dependencies
task :cucumber  => :check_dependencies
