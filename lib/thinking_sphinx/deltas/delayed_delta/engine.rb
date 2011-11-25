module ThinkingSphinx
  module Deltas

      class DelayedDelta::Engine < Rails::Engine
        engine_name :ts_delayed_delta

        rake_tasks do
          load "thinking_sphinx/deltas/delayed_delta/railties/tasks.rake"
        end
      end

  end
end

