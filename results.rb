# Computes precision and recall of the SondaSerimi results.
# Author: Samur Araujo
 
def fmeasure(a,b)
  return 0.0 if a == 0 || b == 0
  2.0 * (a * b)  / (a+b)
end
def check_result()
  puts "CHECKING RESULTS"
  
  solution=[]
  encountered=[]
  subjects=[]
  recall=[]
  precision=[]
  candidates=[]
  
  File.open("reference.txt", 'r').each { |line|
    solution << line.rstrip.gsub("#_","")
  }
  solution.uniq!
  

  File.open( "output.txt", 'r').each { |line|
    encountered << line.rstrip.gsub("#_","")

  }
  encountered.uniq!
   
  
  subjects.uniq!
  puts "SUBJECTS"
  $number_subjects = subjects.uniq.size
  puts $number_subjects
  puts "SUBJECTS FOUND"
  puts encountered.uniq.size
  
  

  golden = solution.map{|x| x.split("=")[0]}
  encountered.delete_if{|x| !golden.include?(x.split("=")[0]) }
  subjects = encountered.map{|x| x.split("=")[0]}
  solution.delete_if{|x| !subjects.include?(x.split("=")[0]) } #if $globalrecall == true

  solution.uniq!
  encountered.uniq!

  # puts solution.sort
  puts "$$$$$$"
  # puts encountered.sort

  puts "######## DIFFERENCE  encountered - solution"

  # puts  encountered - solution

  puts "######## DIFFERENCE  solution - encountered"
  puts (solution - encountered)[0..10]

  positive = 0
  false_positive = 0
  negative = 0
  false_negative = 0
  positive = (solution & encountered).size.to_f
  false_positive = (encountered - solution).size.to_f
  false_negative = (solution - encountered).size.to_f

  puts positive
  puts  false_positive
  puts  false_negative

  precision =(positive.to_f / (positive.to_f + false_positive.to_f))

  recall = (positive.to_f / (positive.to_f + false_negative.to_f))

  fmeasure = fmeasure(recall,precision)#.round(3)

  paircompleteness = (candidates & solution).size.to_f / solution.size.to_f

  puts "PAIRCOMPLETENESS: " + recall.to_s
  puts "RECALL: " + recall.to_s
  puts "PRECISON: " + precision.to_s
  puts "FMEASURE: " + fmeasure.to_s
  return [fmeasure,recall, precision,paircompleteness]
end
 
def missing_entities()
   solution=[]
  encountered=[]
   File.open("reference.txt", 'r').each { |line|
    solution << line.rstrip.gsub("#_","").split("=")[0]
  }
  solution.uniq!
  

  File.open( "output.txt", 'r').each { |line|
    encountered << line.rstrip.gsub("#_","").split("=")[0]

  }
  encountered.uniq!
   
  diff = ( solution - encountered )
  puts "TOTAL REFERENCES #{solution.size}"
  puts "TOTAL MISSING #{diff.size}"
  # puts diff
end
check_result()

missing_entities
 