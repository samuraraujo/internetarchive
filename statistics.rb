#Computes a few statistics about the metadata collect with metadata.rb.
# Author: Samur Araujo

def statistics
lines = File.open("metadata.txt","r").readlines
ambiguous=Hash.new
lines.map!{|line|
   line = line.split(" & ").map{|x| x.lstrip.rstrip}
   ambiguous[line[0]]=[] if ambiguous[line[0]] == nil
   ambiguous[line[0]]<<line   
   line   
} 
lines.compact!

frequency = {}
ambiguous.each{|k,v| frequency[k]=v.size}
 
puts "TOTAL NUMBER OF ENTITIES: #{frequency.keys.size}"
puts 
puts "NUMBER OF AMBIGUOUS  ENTITIES: #{frequency.delete_if{|k,v| v == 1}.keys.size}"

average = frequency.values.inject(0){|sum,x| sum + x }.to_f / frequency.values.size.to_f 
puts "AVERAGE AMBIGUOUS ENTITIES PER ENTITY: #{average.to_i}"
# frequency.sort{|x,y| x[1]<=>y[1]}

 
puts 
sum_website=lines.map{|x|    
   if x[2].size > 0
   1 else
   0 end  
   }.inject(0){|sum,x| sum + x }

sum_location=lines.map{|x|   
  if x[3]!= nil && x[3].size > 0
   1 else
   0 end}.inject(0){|sum,x| sum + x }
sum_dbpedia=lines.map{|x| if x[4]!= nil && x[4].size > 0
   1 else
   0 end}.inject(0){|sum,x| sum + x }

sum_website = sum_website.to_f / lines.size.to_f
sum_location = sum_location.to_f / lines.size.to_f
sum_dbpedia = sum_dbpedia.to_f / lines.size.to_f

puts "COVERAGE BAND WEBSITE:  #{sum_website}"
puts "COVERAGE BAND LOCATION: #{sum_location}"
puts "COVERAGE BAND DBPEDIA:  #{sum_dbpedia}"   
end 
statistics