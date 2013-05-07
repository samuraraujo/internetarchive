require  File.dirname(__FILE__)+ '/active_rdf/lib/active_rdf'
require  File.dirname(__FILE__)+'/activerdf_sparql-1.3.6/lib/activerdf_sparql/init'

$session = Hash.new

#initialize the source and target dataset source object connector
def metadata()
  $session[:target] = mount_adapter("http://dbtune.org/musicbrainz/sparql?query=",:post,false)
  $session[:dbpedia] = mount_adapter("http://dbpedia.org/sparql",:post,false)
  data =[]
  File.open("metadata.txt", 'w') {|o|
    lines = File.open("output.txt", 'r').readlines
    lines.each{|line|
      puts "QUERY #{line}"
      row=[]

      line = line.rstrip.gsub("#_","").split("=")
      row << line[0]
      row << " & "
      row << line[1]
      row << " & "
      query = "SELECT distinct *  WHERE  { <#{line[1].gsub("musicbrainz.org","dbtune.org/musicbrainz/resource")}> <http://www.w3.org/2002/07/owl#sameAs> ?o} "
      results = Query.new.adapters($session[:target]).sparql(query).execute.flatten
      puts "SAMEAS"
      puts results

      results.delete_if{|x| x.to_s.index("dbpedia") == nil}
      puts "METADATA"
      if results.size > 0
        x = results[0].to_s.gsub("%28","(").gsub("%29",")")
        puts x
        query = "SELECT distinct *  WHERE  {{ #{x} <http://xmlns.com/foaf/0.1/homepage> ?o} union { #{x} <http://dbpedia.org/property/website> ?o} union { #{x} <http://dbpedia.org/ontology/wikiPageRedirects> ?y . ?y <http://dbpedia.org/property/website> ?o} union { #{x} <http://dbpedia.org/ontology/wikiPageRedirects> ?y . ?y  <http://xmlns.com/foaf/0.1/homepage> ?o}} "
        results = Query.new.adapters($session[:dbpedia]).sparql(query).execute.flatten
        row << results[0].to_s.gsub(">", "").gsub("<","") if results.size > 0
        row << " & "
        query = "SELECT distinct *  WHERE  {{ #{x} <http://dbpedia.org/ontology/hometown> ?o} union { #{x} <http://dbpedia.org/ontology/wikiPageRedirects> ?y . ?y   <http://dbpedia.org/ontology/hometown> ?o} union { #{x} <http://dbpedia.org/property/origin> ?o} union { #{x} <http://dbpedia.org/ontology/wikiPageRedirects> ?y . ?y  <http://dbpedia.org/property/origin> ?o} }"
        results = Query.new.adapters($session[:dbpedia]).sparql(query).execute.flatten
      row << results[0].to_s.gsub("<http://dbpedia.org/resource/","").gsub(">","").gsub("_"," ")  if results.size > 0
      row << " & "
      row << x
      end
      o.write(row.join(" "))
      o.write("\n")

    }
  }

end

def mount_adapter(endpoint, method=:post,cache=true)

  adapter=nil
  begin
    adapter = ConnectionPool.add_data_source :type => :sparql, :engine => :virtuoso, :title=> endpoint , :url =>  endpoint, :results => :sparql_xml, :caching => cache , :request_method => method

  rescue Exception => e
    puts e.getMessage()
    return nil
  end
  return adapter
end

metadata()
