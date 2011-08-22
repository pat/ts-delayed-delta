require 'spec_helper'

describe ThinkingSphinx::Deltas::DeltaJob do
  describe '#perform' do
    before :each do
      ThinkingSphinx.suppress_delta_output = false
      
      @delta_job = ThinkingSphinx::Deltas::DeltaJob.new(['foo_core'])
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
    
    it "should process just the requested indexes" do
      @delta_job.should_receive(:`) do |command|
        command.should match(/foo_core/)
        command.should_not match(/--all/)
      end
      
      @delta_job.perform
    end
    
    context 'multiple indexes' do
      it "should process all requested indexes" do
        @delta_job.indexes = ['foo_core', 'bar_core']
        @delta_job.should_receive(:`) do |command|
          command.should match(/foo_core bar_core/)
        end

        @delta_job.perform
      end
    end
  end

  describe "#display_name" do
    it "should display class name with all indexes" do
      @delta_job = ThinkingSphinx::Deltas::DeltaJob.new(['foo_core', 'bar_core'])
      @delta_job.display_name.should == "ThinkingSphinx::Deltas::DeltaJob for foo_core, bar_core"
    end
  end
end
