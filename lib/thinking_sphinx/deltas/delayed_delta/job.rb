class ThinkingSphinx::Deltas::Job < Delayed::Job
  def self.enqueue(object, priority = 0)
    Delayed::Job.enqueue(object, priority) unless duplicates_exist(object)
  end
  
  def self.cancel_thinking_sphinx_jobs
    if connection.tables.include?("delayed_jobs")
      delete_all("handler LIKE '--- !ruby/object:ThinkingSphinx::Deltas::%'")
    end
  end
  
  # This is to stop ActiveRecord complaining about a missing database when
  # running specs.
  # 
  def self.inspect
    "Job"
  end
  
  private
  
  def self.duplicates_exist(object)
    count(
      :conditions => {
        :handler    => object.to_yaml,
        :locked_at  => nil
      }
    ) > 0
  end
end
