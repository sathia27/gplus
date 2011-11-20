=begin
Program name: Gplus script
Date Written: 16/08/2011
Date Modified: 17/08/2011
Author : Sathianarayanan.S
License: GPL2.0
Version: 1.1
=end
begin
require 'rubygems'
require 'mechanize'
require "highline/import"

print "Enter your username: "
username = gets.chomp
password = ask("Enter the password :" ) { |p| p.echo = "*" }
password = password.chomp

agent = Mechanize.new
agent.user_agent_alias = 'Mac Safari'
page = agent.get("https://www.google.com/accounts/ServiceLogin?service=oz&continue=https://plus.google.com/?gpcaz%3D94cd3e2c&ltmpl=es2st&hideNewAccountLink=1&hl=en-GB")
puts 'Logggig....'
puts "=========================================================================\n"
form = page.forms.first
form.Email = username
form.Passwd = password

page = agent.submit form
circles = agent.page.search('#content')

puts 'Streams:'
i = 1
circles.each do |circle|
  puts i.to_s+') '+circle
  i+=1
end
puts "=========================================================================\n"
while true
 print "Enter circle: "
 circle_name = gets.chomp

 page = agent.page.link_with(:text => circle_name).click

 streams = page.search('#contentPane div.gi.rh')
 i = 1
 streams.each do |stream|
   if stream.text != ''
     puts i.to_s+') '+stream.search('span.Ex a').text+' shared:'
     puts stream.search('div.Tx').text
   else
     puts  i.to_s+') '+'Video/photos...'
   end
   puts ''
   i+=1
 end
 puts "=========================================================================\n"
end

rescue SocketError
 puts 'Error in internet connection'
rescue NoMethodError
  puts 'Invalid username or password or circle'
rescue Interrupt
  puts "\n========================================================================="
  puts "\nQuiting...."
end
