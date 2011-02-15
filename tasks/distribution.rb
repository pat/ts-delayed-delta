YARD::Rake::YardocTask.new

Jeweler::Tasks.new do |gem|
  gem.name        = 'ts-delayed-delta'
  gem.summary     = 'Thinking Sphinx - Delayed Deltas'
  gem.description = 'Manage delta indexes via Delayed Job for Thinking Sphinx'
  gem.email       = "pat@freelancing-gods.com"
  gem.homepage    = "http://github.com/freelancing-god/ts-delayed-delta"
  gem.authors     = ["Pat Allan"]
  
  gem.files = FileList[
    'lib/**/*.rb',
    'LICENSE',
    'README.textile'
  ]
  gem.test_files = FileList[
    'features/**/*.feature',
    'features/**/*.rb',
    'features/**/database.example.yml',
    'spec/**/*.rb'
  ]
end

Jeweler::GemcutterTasks.new
