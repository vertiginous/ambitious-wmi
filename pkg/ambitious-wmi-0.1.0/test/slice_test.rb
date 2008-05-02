require File.dirname(__FILE__) + '/helper'

context "WMI Adapter :: Slice" do
  setup do
    @klass = @klass = WMI::Win32_Service
    @block = @klass.select { |m| m.state == 'running' }
  end

  specify "first" do
    @klass.expects(:find).with(:state => 'running')
    @block.first
  end

  xspecify "first with argument" do
    @klass.expects(:find).with(:limit => 5, :name => 'C:')
    @block.first(5).entries
  end

  xspecify "[] with two elements" do
    @klass.expects(:find).with(:limit => 20, :offset => 10, :name => 'C:')
    @block[10, 20].entries

    @klass.expects(:find).with(:limit => 20, :offset => 20, :name => 'C:')
    @block[20, 20].entries
  end

  xspecify "slice is an alias of []" do
    @klass.expects(:find).with(:limit => 20, :offset => 10, :name => 'C:')
    @block.slice(10, 20).entries
  end

  xspecify "[] with range" do
    @klass.expects(:find).with(:limit => 10, :offset => 10, :name => 'C:')
    @block[11..20].entries
  end
end
