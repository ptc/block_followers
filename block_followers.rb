require 'rubygems'
require 'highline/import'
require 'twitter'

def login_on_twitter
  screen_name = ask("enter your screen name: ") {|q| q.echo = true}
  password = ask("enter your password: ") {|q| q.echo = false }

  httpauth = Twitter::HTTPAuth.new(screen_name,password,:ssl => true)
  @client = Twitter::Base.new(httpauth)
  begin
    @client.verify_credentials
  rescue Twitter::Unauthorized
    puts "login failed! wrong credentials..."
    exit
  end
end

def block_users
  friends = @client.friend_ids
  followers = @client.follower_ids
  to_be_blocked = followers - friends
  
  if to_be_blocked.empty? 
    puts "no bots detected, exiting..."
    exit
  end
  
  to_be_blocked.each do |id|
    user = @client.user id
    puts "block #{user.name} (#{user.screen_name})? [Yn]"
    confirmation = gets.chomp
    @client.block(id) if confirmation == "Y"
  end
end

login_on_twitter
block_users

