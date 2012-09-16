namespace :thinking_sphinx do
  task :index do
    require 'thinking_sphinx/deltas/delayed_delta'
    ThinkingSphinx::Deltas::DelayedDelta.cancel_jobs
  end
end
