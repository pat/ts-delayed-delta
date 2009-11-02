class ThinkingSphinx::Deltas::DeltaJob
  attr_accessor :index
  
  def initialize(index)
    @index = index
  end
  
  def perform
    config = ThinkingSphinx::Configuration.instance
    
    output = `#{config.bin_path}#{config.indexer_binary_name} --config #{config.config_file} --rotate #{index}`
    puts output unless ThinkingSphinx.suppress_delta_output?
    
    true
  end
end
