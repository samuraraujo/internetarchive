# Auxiliar script.
# Author: Samur Araujo

def reference
require "uri"
lines = File.open("internetarchive.csv","r").readlines
f = File.open("reference.txt", "w")
count=1
lines.each{|line|
  puts line
  count+=1
  puts count
  line = line.gsub(", ", ";").split(",")
  puts line.size 
  puts URI(line[4].rstrip)
  if line.size !=5  
    puts "error"
    exit
  end
  line[0].gsub!('"',"")
  line[3].gsub!('"',"")
  line[1].gsub!('https',"http")
  line[2]=line[2].rstrip.gsub("N/A","")
  line[4]=line[4].rstrip.gsub("N/A","")
  if line[2].rstrip.size>0
   f.write "#{line[1]}=#{line[2]}\n"
  else
   #f.write "#{line[1]}=#{line[1]}\n"
   end 
  }
end 
reference