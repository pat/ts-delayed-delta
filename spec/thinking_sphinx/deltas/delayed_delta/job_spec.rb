require 'spec_helper'

describe ThinkingSphinx::Deltas::Job do
  describe '.enqueue' do
    before :each do
      ThinkingSphinx::Deltas::Job.stub!(:count => 0)
    end

    it "should enqueue if there's no existing jobs for the same index" do
      Delayed::Job.should_receive(:enqueue)

      ThinkingSphinx::Deltas::Job.enqueue(stub('object'))
    end

    it "should not enqueue the job if there's an existing job already" do
      ThinkingSphinx::Deltas::Job.stub!(:count => 1)
      Delayed::Job.should_not_receive(:enqueue)

      ThinkingSphinx::Deltas::Job.enqueue(stub('object'))
    end
  end

  describe '.cancel_thinking_sphinx_jobs' do
    before :each do
      ThinkingSphinx::Deltas::Job.stub!(:connection => double('connection'))
      ThinkingSphinx::Deltas::Job.stub!(:delete_all => true)
    end

    it "should not delete any rows if the delayed_jobs table does not exist" do
      ThinkingSphinx::Deltas::Job.connection.stub!(:tables => [])
      ThinkingSphinx::Deltas::Job.should_not_receive(:delete_all)

      ThinkingSphinx::Deltas::Job.cancel_thinking_sphinx_jobs
    end

    it "should delete rows if the delayed_jobs table does exist" do
      ThinkingSphinx::Deltas::Job.connection.stub!(:tables => ['delayed_jobs'])
      ThinkingSphinx::Deltas::Job.should_receive(:delete_all)

      ThinkingSphinx::Deltas::Job.cancel_thinking_sphinx_jobs
    end

    it "should delete only Thinking Sphinx jobs" do
      ThinkingSphinx::Deltas::Job.connection.stub!(:tables => ['delayed_jobs'])
      ThinkingSphinx::Deltas::Job.should_receive(:delete_all) do |sql|
        sql.should match(/handler LIKE '--- !ruby\/object:ThinkingSphinx::Deltas::\%'/)
      end

      ThinkingSphinx::Deltas::Job.cancel_thinking_sphinx_jobs
    end
  end
end
