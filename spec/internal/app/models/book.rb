class Book < ActiveRecord::Base
  define_index do
    indexes title, author

    set_property :delta => ThinkingSphinx::Deltas::DelayedDelta
  end if respond_to?(:define_index)
end
