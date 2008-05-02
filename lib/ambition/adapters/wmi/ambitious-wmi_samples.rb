require 'ambition/adapters/wmi'

#~ ruby-wmi
running = WMI::Win32_Service.find(:all, :conditions => {:state => 'running'})

#~ ambitious-wmi
running = WMI::Win32_Service.select{|s| s.state == 'running'}

running.each{|s| p s }

running = WMI::Win32_Service.sort_by{|i| i.state}
