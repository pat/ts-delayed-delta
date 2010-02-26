require 'delayed_job'
require 'thinking_sphinx'
require 'thinking_sphinx/deltas/delayed_delta/delta_job'
require 'thinking_sphinx/deltas/delayed_delta/flag_as_deleted_job'
require 'thinking_sphinx/deltas/delayed_delta/job'

# Delayed Deltas for Thinking Sphinx, using Delayed Job.
# 
# This documentation is aimed at those reading the code. If you're looking for
# a guide to Thinking Sphinx and/or deltas, I recommend you start with the
# Thinking Sphinx site instead - or the README for this library at the very
# least.
# 
# @author Patrick Allan
# @see http://ts.freelancing-gods.com Thinking Sphinx
#
class ThinkingSphinx::Deltas::DelayedDelta < ThinkingSphinx::Deltas::DefaultDelta
  
  # Adds a job to the queue for processing the given model's delta index. A job
  # for hiding the instance in the core index is also created, if an instance is
  # provided.
  # 
  # Neither job will be queued if updates or deltas are disabled, or if the 
  # instance (when given) is not toggled to be in the delta index. The first two
  # options are controlled via ThinkingSphinx.updates_enabled? and
  # ThinkingSphinx.deltas_enabled?.
  # 
  # @param [Class] model the ActiveRecord model to index.
  # @param [ActiveRecord::Base] instance the instance of the given model that
  #   has changed. Optional.
  # @return [Boolean] true
  # 
  def index(model, instance = nil)
    return true if skip? instance
    
    ThinkingSphinx::Deltas::Job.enqueue(
      ThinkingSphinx::Deltas::DeltaJob.new(model.delta_index_names),
      ThinkingSphinx::Configuration.instance.delayed_job_priority
    )
    
    Delayed::Job.enqueue(
      ThinkingSphinx::Deltas::FlagAsDeletedJob.new(
        model.core_index_names, instance.sphinx_document_id
      ),
      ThinkingSphinx::Configuration.instance.delayed_job_priority
    ) if instance
    
    true
  end
  
  private
  
  # Checks whether jobs should be enqueued. Only true if updates and deltas are
  # enabled, and the instance (if there is one) is toggled.
  # 
  # @param [ActiveRecord::Base, NilClass] instance
  # @return [Boolean]
  # 
  def skip?(instance)
    !ThinkingSphinx.updates_enabled? ||
    !ThinkingSphinx.deltas_enabled?  ||
    (instance && !toggled(instance))
  end
end
