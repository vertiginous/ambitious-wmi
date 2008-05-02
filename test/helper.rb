%w( rubygems test/spec mocha English ).each { |f| require f }

begin
  require 'redgreen'
  require 'win32console'
rescue LoadError
end

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'ambition/adapters/wmi'
