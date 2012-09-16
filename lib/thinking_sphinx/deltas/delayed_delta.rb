require 'delayed_job'
require 'thinking_sphinx'

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
class ThinkingSphinx::Deltas::DelayedDelta <
  ThinkingSphinx::Deltas::DefaultDelta

  def self.cancel_jobs
    Delayed::Job.delete_all(
      "handler LIKE '--- !ruby/object:ThinkingSphinx::Deltas::%'"
    )
  end

  def self.enqueue_unless_duplicates(object)
    return if Delayed::Job.where(
      :handler => object.to_yaml,
      :locked_at => nil
    ).count > 0

    Delayed::Job.enqueue object, :priority => priority
  end

  def self.priority
    ThinkingSphinx::Configuration.instance.settings['delayed_job_priority'] || 0
  end

  def delete(index, instance)
    Delayed::Job.enqueue(
      ThinkingSphinx::Deltas::DelayedDelta::FlagAsDeletedJob.new(
        index.name, index.document_id_for_key(instance.id)
      ), :priority => self.class.priority
    )
  end

  # Adds a job to the queue for processing the given index.
  #
  # @param [Class] index the Thinking Sphinx index object.
  #
  def index(index)
    self.class.enqueue_unless_duplicates(
      ThinkingSphinx::Deltas::DelayedDelta::DeltaJob.new(index.name)
    )
  end
end

require 'thinking_sphinx/deltas/delayed_delta/delta_job'
require 'thinking_sphinx/deltas/delayed_delta/flag_as_deleted_job'
require 'thinking_sphinx/deltas/delayed_delta/railtie' if defined?(Rails)
