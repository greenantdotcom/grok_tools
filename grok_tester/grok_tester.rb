#!/usr/bin/env ruby

path_to_here = File.expand_path(File.dirname(__FILE__) + "/")

require "rubygems"
require "grok"
require "pp"
require "csv"

grok = Grok.new

# Load some default patterns that ship with grok.
# See also: 
#   http://code.google.com/p/semicomplete/source/browse/grok/patterns/base
grok.add_patterns_from_file( path_to_here + "/../grok-patterns/base")
grok.add_patterns_from_file( path_to_here + "/../grok-patterns/areslogs")

# Using the patterns we know, try to build a grok pattern that best matches 
# a string we give. Let's try Time.now.to_s, which has this format;
# => Fri Apr 16 19:15:27 -0700 2010
# input = "2010-04-18T15:06:02Z"
# pattern = "%{TIMESTAMP_ISO8601}"
# grok.compile(pattern)
# grok.compile(pattern)
# puts "Input: #{input}"
# puts "Pattern: #{pattern}"
# puts "Full: #{grok.expanded_pattern}"
# 
# match = grok.match(input)
# if match
#   puts "Resulting capture:"
#   pp match.captures
# end
# 
# puts "-------------------------------------------------";
# puts "-------------------------------------------------";
# puts "-------------------------------------------------";
# puts "-------------------------------------------------";

filepath = path_to_here + "/webserver1_05nov_access_log"
filepath = "/logs/webserver1_05nov_access_log"
#filepath = path_to_here + "/trouble_log.orig"

fp = File.open( filepath, "r" )

pattern = "%{ARESWEBLOGFULL}"
grok.compile(pattern)
puts "Pattern: #{pattern}"
puts "Full: #{grok.expanded_pattern}"

scoreboard = { :good => 0, :bad => 0 }

agents = {}

lines   = 0
maxlines  = 10

while( input = fp.gets )
  # puts "Input: #{input}"
  match = grok.match(input)
  if match
    #puts "Input: #{input}"
    # print "+"
    
    scoreboard[:good] += 1
    
    puts "Resulting capture:"
    pp match.captures
    
  else
    # print "-"
    
    scoreboard[:bad] += 1
    
    # pattern = "%{ARESCOMBLOGSD2}"
    # grok.compile(pattern)

    # print "-"
    # puts 'doh'
    # puts "#{input}"
    
    trouble_fp.puts( input )
    
    # match = grok.match(input)
    # pp match.captures
    
    # Kernel.exit( 1 )
  end
  
  lines += 1
  
  break if( maxlines > 0 && lines >= maxlines )
end

pp scoreboard
