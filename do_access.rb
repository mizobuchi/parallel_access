require 'rubygems'
require 'net/ssh'

# サーバ情報読み込み
#ips = $stdin.readlines.map do |line|
#  label, host, user = line.split(' ', 3)
#  info = {label => label , host => host, user => user}
#end
f = open("tmp.txt")
ips = f.map do |line|
  label, host, user = line.split(' ', 3)
  {:label => label , :host => host, :user => user}
end

#各コマンド実行
comm = $stdin.readlines.map do |num|
  commands = num.split(',')
  ips.each_with_index do |server, i|
    puts server[:host]
    puts server[:user]
    Thread.new do
      output = nil
      Net::SSH.start(server[:host], server[:user]) { |ssh| output = ssh.exec!(commands[i]) }
      output.to_s
      puts output
    end
#    thread.value.each_line.map do |line|
#      output = nil
#      Net::SSH.start(host, user) { |ssh| output = ssh.exec!(commands[line]) }
#      output.to_s
#      puts "  " + line
#    end
  end
end
