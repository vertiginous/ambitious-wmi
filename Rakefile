require 'rake'

Version = '0.1.0'

begin
  require 'rubygems'
  gem 'echoe', '>=2.7'
  ENV['RUBY_FLAGS'] = ""
  require 'echoe'

  Echoe.new('ambitious-wmi') do |p|
    p.dependencies  << 'ruby-wmi >=0.2.2'
    p.summary        = "An ambitious adapter for Wmi"
    p.author         = 'Your Name'
    p.email          = "your@email.com"

    p.project        = 'ambition'
    p.url            = "http://ambition.rubyforge.org/"
    p.test_pattern   = 'test/*_test.rb'
    p.version        = Version
    p.dependencies  << 'ambition >=0.5.0'
  end

rescue LoadError 
  puts "Not doing any of the Echoe gemmy stuff, because you don't have the specified gem versions"
end

desc 'Install as a gem'
task :install_gem do
  puts `rake manifest package && gem install pkg/ambitious-wmi-#{Version}.gem`
end
