namespace :thinking_sphinx do
  task :index do
    ThinkingSphinx::Deltas::Job.cancel_thinking_sphinx_jobs
  end
  
  desc "Process stored delta index requests"
  task :delayed_delta => :app_env do
    require 'delayed/worker'
    require 'thinking_sphinx/deltas/delayed_delta'
    
    Delayed::Worker.new(
      :min_priority => ENV['MIN_PRIORITY'],
      :max_priority => ENV['MAX_PRIORITY']
    ).start
  end
end

namespace :ts do
  desc "Process stored delta index requests"
  task :dd => "thinking_sphinx:delayed_delta"
end
