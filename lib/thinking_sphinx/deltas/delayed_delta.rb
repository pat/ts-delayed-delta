require 'delayed_job'

require 'thinking_sphinx/deltas/delayed_delta/delta_job'
require 'thinking_sphinx/deltas/delayed_delta/flag_as_deleted_job'
require 'thinking_sphinx/deltas/delayed_delta/job'

class ThinkingSphinx::Deltas::DelayedDelta < ThinkingSphinx::Deltas::DefaultDelta
  def index(model, instance = nil)
    return true if skip? instance
    
    ThinkingSphinx::Deltas::Job.enqueue(
      ThinkingSphinx::Deltas::DeltaJob.new(delta_index_name(model)),
      ThinkingSphinx::Configuration.instance.delayed_job_priority
    )
    
    Delayed::Job.enqueue(
      ThinkingSphinx::Deltas::FlagAsDeletedJob.new(
        core_index_name(model), instance.sphinx_document_id
      ),
      ThinkingSphinx::Configuration.instance.delayed_job_priority
    ) if instance
    
    true
  end
  
  private
  
  def skip?(instance)
    !ThinkingSphinx.updates_enabled? ||
    !ThinkingSphinx.deltas_enabled?  ||
    (instance && !toggled(instance))
  end
end
