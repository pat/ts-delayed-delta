# A simple job class that processes a given index.
# 
class ThinkingSphinx::Deltas::DeltaJob
  attr_accessor :indexes
  
  # Initialises the object with an index name.
  # 
  # @param [String] index the name of the Sphinx index
  # 
  def initialize(indexes)
    @indexes = indexes
  end
  
  # Shows index name in Delayed::Job#name.
  # 
  def display_name
    "#{self.class.name} for #{indexes.join(', ')}"
  end
  
  # Runs Sphinx's indexer tool to process the index. Currently assumes Sphinx is
  # running.
  # 
  # @return [Boolean] true
  # 
  def perform
    config = ThinkingSphinx::Configuration.instance
    
    output = `#{config.bin_path}#{config.indexer_binary_name} --config #{config.config_file} --rotate #{indexes.join(' ')}`
    puts output unless ThinkingSphinx.suppress_delta_output?
    
    true
  end
end
