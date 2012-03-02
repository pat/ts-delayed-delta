module Delayed
  module Backend
    module ActiveRecord
      class Job < ::ActiveRecord::Base
        self.table_name = "delayed_jobs"
      end
    end
  end
end

# A custom job model, subclassed from Delayed::Job. The two things it does
# differently is that it checks for duplicate tasks before enqueuing them, and
# provides the option to remove all Delayed Delta jobs from the queue.
# 
# As such, this class should not be used for any other tasks.
# 
class ThinkingSphinx::Deltas::Job < Delayed::Backend::ActiveRecord::Job
  self.table_name = "delayed_jobs"
  # Adds a job to the queue, if it doesn't already exist. This is to ensure
  # multiple indexing requests for the same delta index don't get added, as the
  # index only needs to be processed once.
  # 
  # Because indexing jobs are all the same object, with a single instance
  # variable (the index name), they all get serialised to the same YAML value.
  # 
  # @param [Object] object The job, which must respond to the #perform method.
  # @param [Integer] priority (0)
  # 
  def self.enqueue(object, priority = 0)
    options = if Gem.loaded_specs['delayed_job'].version.to_s.match(/^2\.0\./)
      # Fallback for compatibility with old release 2.0.x of DJ
      priority
    else
      { :priority => priority }
    end
      
    ::Delayed::Job.enqueue(object, options) unless duplicates_exist(object)
  end
  
  # Remove all Thinking Sphinx/Delayed Delta jobs from the queue. If the
  # delayed_jobs table does not exist, this method will do nothing.
  # 
  def self.cancel_thinking_sphinx_jobs
    if connection.tables.include?("delayed_jobs")
      delete_all("handler LIKE '--- !ruby/object:ThinkingSphinx::Deltas::%'")
    end
  end
  
  # This is to stop ActiveRecord complaining about a missing database when
  # running specs (otherwise printing failure messages raises confusing stack
  # traces).
  # 
  def self.inspect
    "Job"
  end
  
  private
  
  # Checks whether a given job already exists in the queue.
  # 
  # @param [Object] object The job
  # @return [Boolean] True if a duplicate of the job already exists in the queue
  # 
  def self.duplicates_exist(object)
    count(
      :conditions => {
        :handler    => object.to_yaml,
        :locked_at  => nil
      }
    ) > 0
  end
end
