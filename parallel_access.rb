require 'rubygems'
require 'net/ssh'

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

servers = []
File.open("server.info") do |f|
  f.each_line do |line|
    label, host, user = line.split(' ')
    servers.push( {:label => label , :host => host, :user => user} )
  end
end

ips = $stdin.readlines.map do |line|
  make_thread(servers, line).each do |label,thread,command|
    thread.join
    puts command
    p Thread::list
  end
end
