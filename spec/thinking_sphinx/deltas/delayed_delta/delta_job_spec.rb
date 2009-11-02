require 'spec/spec_helper'

describe ThinkingSphinx::Deltas::DeltaJob do
  describe '#perform' do
    before :each do
      ThinkingSphinx.suppress_delta_output = false
      
      @delta_job = ThinkingSphinx::Deltas::DeltaJob.new('foo_core')
      @delta_job.stub! :`    => true
      @delta_job.stub! :puts => nil
    end
    
    it "should output the delta indexing by default" do
      @delta_job.should_receive(:puts)
      
      @delta_job.perform
    end
    
    it "should not output the delta indexing if requested" do
      ThinkingSphinx.suppress_delta_output = true
      @delta_job.should_not_receive(:puts)
      
      @delta_job.perform
    end
    
    it "should process just the requested index" do
      @delta_job.should_receive(:`) do |command|
        command.should match(/foo_core/)
        command.should_not match(/--all/)
      end
      
      @delta_job.perform
    end
  end
end
