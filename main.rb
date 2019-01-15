#!/usr/bin/ruby

require 'uri'
require 'http'
require 'json'
require 'date'


def make_web_request(target)
  return HTTP.get(target)
end

def parse_remote_json(target)
  return JSON.parse(make_web_request(target))
end

def print_full_rant_from_json(rant)
  puts "\nCreated at: " + Time.at(rant['created_time']).to_s
  puts rant['score'].to_s + '++'
  puts "Posted by #{rant["user_username"]} (#{rant["user_score"]} ++)\n"

  puts rant['text']

  if rant['attached_image'] != ''
    puts "\n[IMAGE ATTACHED] (#{rant["attached_image"]["url"]})"
  end
end

def get_random_rant
  return parse_remote_json('https://devrant.com/api/devrant/rants/surprise?app=3')['rant']
end

def get_rant_by_category(category)
  rants = parse_remote_json("https://devrant.com/api/devrant/search?app=3&term=#{category}")
  rand_int = SecureRandom.random_number(rants["results"].length - 1) + 1

  return rants["results"][rand_int]
end

def get_rant_by_id(id)

end

def event_loop
  print "[(r)andom / j(oke/meme) / q(uestion)] $ "
  input = gets.chomp
  
  if input === ''
    print_full_rant_from_json(get_random_rant)
  elsif input === 'r'
    print_full_rant_from_json(get_rant_by_category("random"))
  elsif input === 'j'
    print_full_rant_from_json(get_rant_by_category("joke/meme"))
  elsif input === 'q'
    print_full_rant_from_json(get_rant_by_category("question"))
  end

  event_loop
end

File.open("logo.txt", "r") do |f|
  f.each_line do |line|
    puts line
  end
end

puts "RubyRant v1.1\nWritten by PrivateGER\n\nPress ENTER for random rant."

event_loop