class ThinkingSphinx::Deltas::DelayedDelta::Railtie < Rails::Railtie
  rake_tasks do
    load 'thinking_sphinx/deltas/delayed_delta/tasks.rb'
  end
end
