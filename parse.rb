 
def parse
require "uri"
lines = File.open("internetarchive.csv","r").readlines
f = File.open("internetarchive.nt", "w")
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
   f.write "<#{line[1]}> <http://internetarchive.org/label> \"#{line[0]}\" .\n"
   f.write "<#{line[1]}> <http://internetarchive.org/musicbrainz> <#{line[2]}> .\n" if line[2].rstrip.size>0
   f.write "<#{line[1]}> <http://internetarchive.org/location> \"#{line[3]}\" .\n" if line[3].rstrip.size>0
   f.write "<#{line[1]}> <http://internetarchive.org/site> <#{line[4].rstrip}> .\n" if line[4].rstrip.size>0
   f.write "<#{line[1]}> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://internetarchive.org/class/Band> .\n" 
   
    
  }
end
parse