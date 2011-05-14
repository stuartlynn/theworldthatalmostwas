task :build_data  => :environment do
  
  file = JSON.parse(IO.read("parsed_book.json"))
end