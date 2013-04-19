# A simple job class that processes a given index.
#
class ThinkingSphinx::Deltas::DelayedDelta::DeltaJob
  # Initialises the object with an index name.
  #
  # @param [String] index the name of the Sphinx index
  #
  def initialize(index)
    @index = index
  end

  # Shows index name in Delayed::Job#name.
  #
  def display_name
    "Thinking Sphinx: Process #{@index}"
  end

  # Processes just the given index. Output is hidden only if the quiet_deltas
  # setting is true.
  #
  def perform
    ThinkingSphinx::Deltas::IndexJob.new(@index).perform
  end
end
