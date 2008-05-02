require 'ambition'
require 'activesupport'
require 'ruby-wmi'
require 'ambition/adapters/wmi/base'
require 'ambition/adapters/wmi/query'
require 'ambition/adapters/wmi/select'
require 'ambition/adapters/wmi/sort'
require 'ambition/adapters/wmi/slice'

##
# This is where you inject Ambition into your target.
#
# Use `extend' if you are injecting a class, `include' if you are
# injecting instances of that class.
#
# You must also set the `ambition_adapter' class variable on your target
# class, regardless of whether you are injecting instances or the class itself.
#
# You probably want something like this:
#

WMI::Base.extend Ambition::API
WMI::Base.ambition_adapter = Ambition::Adapters::WMI

