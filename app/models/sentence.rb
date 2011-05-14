class Sentence 
  include MongoMapper::Document
  
  key :content, String,:required => true, :unique => true
  key :rank, Integer, :required => true , :unique =>true 
  belongs_to :pragraph
  has_many :words 
end
