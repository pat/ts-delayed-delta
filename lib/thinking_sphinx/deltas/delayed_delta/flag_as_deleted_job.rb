# A simple job for flagging a specified Sphinx document in a given index as
# 'deleted'.
#
class ThinkingSphinx::Deltas::DelayedDelta::FlagAsDeletedJob
  # Initialises the object with an index name and document id. Please note that
  # the document id is Sphinx's unique identifier, and will almost certainly not
  # be the model instance's primary key value.
  #
  # @param [String] index The index name
  # @param [Integer] document_id The document id
  #
  def initialize(index, document_id)
    @index, @document_id = index, document_id
  end

  def display_name
    "Thinking Sphinx: Mark #{@document_id} in #{@index} as deleted"
  end

  # Updates the sphinx_deleted attribute for the given document, setting the
  # value to 1 (true). This is not a special attribute in Sphinx, but is used
  # by Thinking Sphinx to ignore deleted values between full re-indexing. It's
  # particularly useful in this situation to avoid old values in the core index
  # and just use the new values in the delta index as a reference point.
  #
  def perform
    ThinkingSphinx::Deltas::DeleteJob.new(@index, @document_id).perform
  end
end
