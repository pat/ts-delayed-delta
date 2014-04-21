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
    Delayed::Job.delete_all([
      "handler LIKE (?) AND locked_at IS NULL AND locked_by IS NULL AND failed_at IS NULL", "--- !ruby/object:ThinkingSphinx::Deltas::%"
    ])
  end

  def self.enqueue_unless_duplicates(object)
    if Delayed::Job.respond_to?(:where)
      return if Delayed::Job.where(
        :handler => object.to_yaml, :locked_at => nil
      ).count > 0
    else
      return if Delayed::Job.count(
        :conditions => {:handler => object.to_yaml, :locked_at => nil}
      ) > 0
    end

    Delayed::Job.enqueue object, job_options
  end

  def self.job_options
    if Gem.loaded_specs['delayed_job'].version.to_s.match(/^2\.0\./)
      # Fallback for compatibility with old release 2.0.x of DJ
      # Only priority option is supported for these versions
      ThinkingSphinx::Configuration.instance.delayed_job_priority || 0
    else
      {
        :priority => job_option(:delayed_job_priority, 0),
        :queue    => job_option(:delayed_job_queue)
      }
    end
  end

  def self.job_option(setting, default = nil)
    configuration = ThinkingSphinx::Configuration.instance
    if configuration.respond_to? setting
      configuration.send(setting)
    elsif configuration.respond_to? :settings
      configuration.settings[setting.to_s] || default
    else
      default
    end
  end

  module Binary
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

      self.class.enqueue_unless_duplicates(
        ThinkingSphinx::Deltas::DelayedDelta::DeltaJob.new(
          model.delta_index_names
        )
      )

      Delayed::Job.enqueue(
        ThinkingSphinx::Deltas::DelayedDelta::FlagAsDeletedJob.new(
          model.core_index_names, instance.sphinx_document_id
        ), self.class.job_options
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

  module SphinxQL
    def delete(index, instance)
      Delayed::Job.enqueue(
        ThinkingSphinx::Deltas::DelayedDelta::FlagAsDeletedJob.new(
          index.name, index.document_id_for_key(instance.id)
        ), self.class.job_options
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

  if [:delayed_job_priority, 'delayed_job_priority'].any? { |method|
    ThinkingSphinx::Configuration.instance_methods.include?(method)
  }
    include Binary
  else
    include SphinxQL
  end
end

require 'thinking_sphinx/deltas/delayed_delta/delta_job'
require 'thinking_sphinx/deltas/delayed_delta/flag_as_deleted_job'

ThinkingSphinx.before_index_hooks << Proc.new {
  ThinkingSphinx::Deltas::DelayedDelta.cancel_jobs
}
