# A simple job class that processes a given index.
# 
class ThinkingSphinx::Deltas::DeltaJob
  attr_accessor :index
  
  # Initialises the object with an index name.
  # 
  # @param [String] index the name of the Sphinx index
  # 
  def initialize(index)
    @index = index
  end
  
  # Runs Sphinx's indexer tool to process the index. Currently assumes Sphinx is
  # running.
  # 
  # @return [Boolean] true
  # 
  def perform
    config = ThinkingSphinx::Configuration.instance
    
    output = `#{config.bin_path}#{config.indexer_binary_name} --config #{config.config_file} --rotate #{index}`
    puts output unless ThinkingSphinx.suppress_delta_output?
    
    true
  end
end
