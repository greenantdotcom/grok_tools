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

filepath = path_to_here + "/webserver1_05nov_access_log"
filepath = "/logs/webserver1_05nov_access_log"
#filepath = path_to_here + "/trouble_log.orig"

fp = File.open( filepath, "r" )

pattern = "%{ARESWEBLOGFULL}"
grok.compile(pattern)
puts "Pattern: #{pattern}"
puts "Full: #{grok.expanded_pattern}"

scoreboard = { :good => 0, :bad => 0 }

trouble_fp  = File.open( 'troublesome_lines.log', 'w' )

lines   = 0
maxlines  = 1000

while( input = fp.gets )
  # puts "Input: #{input}"
  match = grok.match(input)
  if match
    #puts "Input: #{input}"
    #print "+"
    
    scoreboard[:good] += 1
    
    captures  = match.captures
    
    # puts "Resulting capture:"
    # pp captures
  else
    # print "-"
    
    scoreboard[:bad] += 1
    
    # pattern = "%{ARESCOMBLOGSD2}"
    # grok.compile(pattern)

    #print "-"
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

trouble_fp.close

pp scoreboard