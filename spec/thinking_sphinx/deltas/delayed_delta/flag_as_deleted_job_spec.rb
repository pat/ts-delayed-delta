require 'spec_helper'

describe ThinkingSphinx::Deltas::FlagAsDeletedJob do
  describe '#perform' do
    before :each do
      ThinkingSphinx.updates_enabled = true
      @client = stub('client', :update => true)
      
      ThinkingSphinx::Configuration.instance.stub!(:client => @client)
      ThinkingSphinx.stub!(:search_for_id => true)
      ThinkingSphinx.stub!(:sphinx_running? => true)
      
      @job = ThinkingSphinx::Deltas::FlagAsDeletedJob.new(['foo_core'], 12)
    end
    
    it "should not update if Sphinx isn't running" do
      ThinkingSphinx.stub!(:sphinx_running? => false)
      @client.should_not_receive(:update)
      
      @job.perform
    end
    
    it "should not update if the document isn't in the index" do
      ThinkingSphinx.stub!(:search_for_id => false)
      @client.should_not_receive(:update)
      
      @job.perform
    end
    
    it "should update the specified index" do
      @client.should_receive(:update) do |index, attributes, values|
        index.should == 'foo_core'
      end
      
      @job.perform
    end
    
    it "should update all specified indexes" do
      @job.indexes = ['foo_core', 'bar_core']
      @client.should_receive(:update).with('foo_core', anything, anything)
      @client.should_receive(:update).with('bar_core', anything, anything)
      
      @job.perform
    end
    
    it "should update the sphinx_deleted attribute" do
      @client.should_receive(:update) do |index, attributes, values|
        attributes.should == ['sphinx_deleted']
      end
      
      @job.perform
    end
    
    it "should set sphinx_deleted for the given document to true" do
      @client.should_receive(:update) do |index, attributes, values|
        values[12].should == [1]
      end
      
      @job.perform
    end
    
    it "should check for the existence of the document in the specified index" do
      ThinkingSphinx.should_receive(:search_for_id) do |id, index|
        index.should == 'foo_core'
      end
      
      @job.perform
    end
    
    it "should check for the existence of the given document id" do
      ThinkingSphinx.should_receive(:search_for_id) do |id, index|
        id.should == 12
      end
      
      @job.perform
    end
  end
end
