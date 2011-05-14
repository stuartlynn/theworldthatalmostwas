class Paragraph 
  include MongoMapper::Document
  
  key :content, String,:required => true, :unique => true
  key :rank, Integer, :required => true, :unique =>true
  
  has_many :sentences 
  belongs_to :chapter 
end


