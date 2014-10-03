require 'rubygems'
require 'net/ssh'

# サーバ情報読み込み
#ips = $stdin.readlines.map do |line|
#  label, host, user = line.split(' ', 3)
#  info = {label => label , host => host, user => user}
#end
=begin
ips = []
File.open("tmp.txt") do |f|
  f.each_line do |line|
    label, host, user = line.split(' ')
    ips.push( {:label => label , :host => host, :user => user} )
  end
end
=end

def make_thread(servers_info, commands)
  threads = []
  commands = commands.chomp.split(',')
  commands.each_with_index do |command, i|
    threads.push ([servers_info[i][:label], Thread.new do
       output = nil
       Net::SSH.start(servers_info[i][:host],servers_info[i][:user]) { |ssh| output = ssh.exec!(command) }
       output.to_s
     end, command])
  end
  threads
end
servers =[{:label => 'load-test', :host =>'load-test', :user => 'sai-member'}, 
      {:label => 'load-test2', :host =>'load-test2', :user => 'sai-member'},
      {:label => 'load-test3', :host =>'load-test3', :user => 'sai-member'},
      {:label => 'load-test4', :host =>'load-test4', :user => 'sai-member'}]

ips = $stdin.readlines.map do |line|
   make_thread(servers, line).each do |label,thread|
      puts  thread.value
   end
end

