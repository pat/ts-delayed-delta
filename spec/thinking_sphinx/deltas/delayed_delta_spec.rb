require 'spec/spec_helper'

describe ThinkingSphinx::Deltas::DelayedDelta do
  describe '#index' do
    before :each do
      ThinkingSphinx.updates_enabled = true
      ThinkingSphinx.deltas_enabled  = true
      ThinkingSphinx::Configuration.instance.delayed_job_priority = 2
      
      ThinkingSphinx::Deltas::Job.stub!(:enqueue => true)
      Delayed::Job.stub!(:enqueue => true, :inspect => "Delayed::Job")
      
      @delayed_delta = ThinkingSphinx::Deltas::DelayedDelta.new(
        stub('instance'), {}
      )
      @delayed_delta.stub!(:toggled => true)
      
      @model = stub('foo')
      @model.stub!(:name => 'foo')
      @model.stub!(:source_of_sphinx_index => @model)
      @model.stub!(:core_index_names  => ['foo_core'])
      @model.stub!(:delta_index_names => ['foo_delta'])
      
      @instance = stub('instance')
      @instance.stub!(:sphinx_document_id => 42)
    end
    
    context 'updates disabled' do
      before :each do
        ThinkingSphinx.updates_enabled = false
      end
      
      it "should not enqueue a delta job" do
        ThinkingSphinx::Deltas::Job.should_not_receive(:enqueue)
        
        @delayed_delta.index(@model)
      end
      
      it "should not enqueue a flag as deleted job" do
        Delayed::Job.should_not_receive(:enqueue)
        
        @delayed_delta.index(@model)
      end
    end
    
    context 'deltas disabled' do
      before :each do
        ThinkingSphinx.deltas_enabled = false
      end
      
      it "should not enqueue a delta job" do
        ThinkingSphinx::Deltas::Job.should_not_receive(:enqueue)
        
        @delayed_delta.index(@model)
      end
      
      it "should not enqueue a flag as deleted job" do
        Delayed::Job.should_not_receive(:enqueue)
        
        @delayed_delta.index(@model)
      end
    end
    
    context "instance isn't toggled" do
      before :each do
        @delayed_delta.stub!(:toggled => false)
      end
      
      it "should not enqueue a delta job" do
        ThinkingSphinx::Deltas::Job.should_not_receive(:enqueue)
        
        @delayed_delta.index(@model, @instance)
      end
      
      it "should not enqueue a flag as deleted job" do
        Delayed::Job.should_not_receive(:enqueue)
        
        @delayed_delta.index(@model, @instance)
      end
    end
    
    it "should enqueue a delta job for the appropriate indexes" do
      ThinkingSphinx::Deltas::Job.should_receive(:enqueue) do |job, priority|
        job.indexes.should == ['foo_delta']
      end
      
      @delayed_delta.index(@model)
    end
    
    it "should use the defined priority for the delta job" do
      ThinkingSphinx::Deltas::Job.should_receive(:enqueue) do |job, priority|
        priority.should == 2
      end
      
      @delayed_delta.index(@model)
    end
    
    it "should enqueue a flag-as-deleted job for the appropriate indexes" do
      Delayed::Job.should_receive(:enqueue) do |job, priority|
        job.indexes.should == ['foo_core']
      end
      
      @delayed_delta.index(@model, @instance)
    end
    
    it "should enqueue a flag-as-deleted job for the appropriate id" do
      Delayed::Job.should_receive(:enqueue) do |job, priority|
        job.document_id.should == 42
      end
      
      @delayed_delta.index(@model, @instance)
    end
    
    it "should use the defined priority for the flag-as-deleted job" do
      Delayed::Job.should_receive(:enqueue) do |job, priority|
        priority.should == 2
      end
      
      @delayed_delta.index(@model, @instance)
    end
    
    it "should not enqueue a flag-as-deleted job if no instance is provided" do
      Delayed::Job.should_not_receive(:enqueue)
      
      @delayed_delta.index(@model)
    end
  end
end
