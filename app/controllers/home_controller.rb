class HomeController < ApplicationController
  
  def index
    
  end
  
  def people_meets
    Word.find_clusters(JSON.parse(IO.read("data/people.json"))).to_yml
  end
  
  def 
end
