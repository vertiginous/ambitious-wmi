require File.dirname(__FILE__) + '/helper'

context "Wmi Adapter :: Select" do
  setup do
    @klass = WMI::Win32_LogicalDisk
  end

  specify "==" do
    wql = @klass.select { |m| m.name == 'C:' }
    wql.to_s.should == "SELECT * FROM Win32_LogicalDisk WHERE name = 'C:'"
  end

  specify "!=" do
    wql = @klass.select { |m| m.name != 'C:' }
    wql.to_s.should == "SELECT * FROM Win32_LogicalDisk WHERE name <> 'C:'"
  end

  specify "== && ==" do
    wql = @klass.select { |m| m.name == 'C:' && m.drivetype == 3 }
    wql.to_s.should == "SELECT * FROM Win32_LogicalDisk WHERE (name = 'C:' AND drivetype = '3')"
  end

  specify "== || ==" do
    wql = @klass.select { |m| m.name == 'D:' || m.drivetype == 3 }
    wql.to_s.should == "SELECT * FROM Win32_LogicalDisk WHERE (name = 'D:' OR drivetype = '3')"
  end

  specify "mixed && and ||" do
    wql = @klass.select { |m| m.name == 'D:' || m.drivetype == 3 && m.description  == 'Local Fixed Disk' }
    wql.to_s.should == "SELECT * FROM Win32_LogicalDisk WHERE (name = 'D:' OR (drivetype = '3' AND description = 'Local Fixed Disk'))"
  end

  specify "grouped && and ||" do
    wql = @klass.select { |m| (m.name == 'C:' || m.name == 'Z:') && m.drivetype == 3 }
    wql.to_s.should == "SELECT * FROM Win32_LogicalDisk WHERE ((name = 'C:' OR name = 'Z:') AND drivetype = '3')"
  end

  specify ">/<" do
    wql = @klass.select { |m| m.drivetype > 2 }
    wql.to_s.should == "SELECT * FROM Win32_LogicalDisk WHERE drivetype > '2'"

    wql = @klass.select { |m| m.drivetype >= 3 }
    wql.to_s.should == "SELECT * FROM Win32_LogicalDisk WHERE drivetype >= '3'"

    wql = @klass.select { |m| m.drivetype < 5 }
    wql.to_s.should == "SELECT * FROM Win32_LogicalDisk WHERE drivetype < '5'"
  end

  specify "array.include? item" do
    wql = @klass.select { |m| [1, 2, 3, 4].include? m.drivetype }
    wql.to_s.should == "SELECT * FROM Win32_LogicalDisk WHERE drivetype IN ('1', '2', '3', '4')"
  end

  specify "range: (lo..hi).include? item" do
    lo = 3
    hi = 5
    wql = @klass.select { |m| (lo..hi).include? m.drivetype }
    wql.to_s.should == "SELECT * FROM Win32_LogicalDisk WHERE (drivetype >= '3' AND drivetype <= '5')"
  end
  
  
  specify "range: (lo...hi).include? item" do
    lo = 3
    hi = 5
    wql = @klass.select { |m| (lo...hi).include? m.drivetype }
    wql.to_s.should == "SELECT * FROM Win32_LogicalDisk WHERE (drivetype >= '3' AND drivetype < '5')"
  end

  specify "variabled array.include? item" do
    array = [1, 2, 3, 4]
    wql = @klass.select { |m| array.include? m.id }
    wql.to_s.should == "SELECT * FROM Win32_LogicalDisk WHERE id IN ('1', '2', '3', '4')"
  end

  specify "== with variables" do
    drive = 'C:'
    wql = @klass.select { |m| m.name == drive }
    wql.to_s.should == "SELECT * FROM Win32_LogicalDisk WHERE name = 'C:'"
  end

  specify "== with method arguments" do
    def test_it(name)
      wql = @klass.select { |m| m.name == name }
      wql.to_s.should == "SELECT * FROM Win32_LogicalDisk WHERE name = 'C:'"
    end

    test_it('C:')
  end

  specify "== with instance variables" do
    @drive = 'C:'
    wql = @klass.select { |m| m.name == @drive }
    wql.to_s.should == "SELECT * FROM Win32_LogicalDisk WHERE name = 'C:'"
  end

  specify "== with instance variable method call" do
    require 'ostruct'
    @disk = OpenStruct.new(:name => 'C:')

    wql = @klass.select { |m| m.name == @disk.name }
    wql.to_s.should == "SELECT * FROM Win32_LogicalDisk WHERE name = 'C:'"
  end

  specify "== with global variables" do
    $my_disk = 'C:'
    wql = @klass.select { |m| m.name == $my_disk }
    wql.to_s.should == "SELECT * FROM Win32_LogicalDisk WHERE name = 'C:'"
  end

  specify "== with method call" do
    def drive
      'C:'
    end

    wql = @klass.select { |m| m.name == drive }
    wql.to_s.should == "SELECT * FROM Win32_LogicalDisk WHERE name = 'C:'"
  end

  specify "=~ with string" do
    wql = @klass.select { |m| m.name =~ 'C:' }
    wql.to_s.should == "SELECT * FROM Win32_LogicalDisk WHERE name LIKE 'C:'"

    wql = @klass.select { |m| m.name =~ 'C%' }
    wql.to_s.should == "SELECT * FROM Win32_LogicalDisk WHERE name LIKE 'C%'"
  end

  specify "!~ with string" do
    wql = @klass.select { |m| m.name !~ 'C:' }
    wql.to_s.should == "SELECT * FROM Win32_LogicalDisk WHERE name NOT LIKE 'C:'"

    wql = @klass.select { |m| !(m.name =~ 'C:') }
    wql.to_s.should == "SELECT * FROM Win32_LogicalDisk WHERE name NOT LIKE 'C:'"
  end

  xspecify "=~ with regexp" do
    wql = @klass.select { |m| m.name =~ /chris/ }
    wql.to_s.should == %Q(foo)
  end

  xspecify "=~ with regexp flags" do
    wql = @klass.select { |m| m.name =~ /chris/i }
    wql.to_s.should == %Q(foo)
  end

  xspecify "downcase" do
    wql = @klass.select { |m| m.name.downcase =~ 'chris%' }
    wql.to_s.should == %Q(foo)
  end

  xspecify "upcase" do
    wql = @klass.select { |m| m.name.upcase =~ 'chris%' }
    wql.to_s.should == %Q(foo)
  end

  specify "undefined equality symbol" do
    should.raise { @klass.select { |m| m.name =* /chris/ } }
  end

  xspecify "block variable / assigning variable conflict" do
    m = @klass.select { |m| m.name == 'chris' }
    m.should == %Q(foo)
  end
  
  xspecify "== with inline ruby" do
    wql = @klass.select { |m| m.created_at < Time.now.to_swebmDateTime }
    wql.to_s.should == %Q(foo)
  end

  specify "inspect" do
    @klass.select { |u| u.name }.inspect.should.match %r(call #to_s or #to_hash)
  end
end
