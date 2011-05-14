class Word 
  include MongoMapper::Document
  
  key :rank, Integer , :required=>true , :unique=>true 
  key :content, String , :required=>true 
  
  belongs_to :sentence

  def self.find_clusters(words)
    all_matched_words=Words.where(:content=>{"$in"=>:words}).all
    finder = FOF_finder.new(all_matched_words,10)
    finder.find_groups(:clusters_on=>:rank)
  end

  def context 
    sentence = self.sentence
    paragraph = sentence.paragraph
    chapter = paragraph.chapter 
    book = chapter.book
    
  end
  
  

end
