class ThinkingSphinx::Deltas::FlagAsDeletedJob
  attr_accessor :index, :document_id
  
  def initialize(index, document_id)
    @index, @document_id = index, document_id
  end
  
  def perform
    config = ThinkingSphinx::Configuration.instance
    
    config.client.update(
      @index,
      ['sphinx_deleted'],
      {@document_id => [1]}
    ) if ThinkingSphinx.sphinx_running? &&
      ThinkingSphinx::Search.search_for_id(@document_id, @index)
    
    true
  end
end