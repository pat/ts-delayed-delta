module SphinxHelpers
  def sphinx
    @sphinx ||= SphinxController.new
  end

  def index(*indices)
    yield if block_given?

    ThinkingSphinx.before_index_hooks.each &:call
    sphinx.index *indices
    sleep 0.25

    ThinkingSphinx::Connection.pool.clear
  end

  def work
    Delayed::Worker.new.work_off
  end
end

RSpec.configure do |config|
  config.include SphinxHelpers

  config.before :all do |group|
    sphinx.setup && sphinx.start if group.class.metadata[:live]
  end

  config.after :all do |group|
    sphinx.stop if group.class.metadata[:live]
  end
end
