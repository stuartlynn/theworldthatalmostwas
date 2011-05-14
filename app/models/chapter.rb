class Chapter 
  include MongoMapper::Document
  
  key :content, String,:required => true, :unique => true
  key :title, String, :required=>true 
  
  has_many :paragraphs
  belongs_to :book
  
end
