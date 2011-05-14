task :generate_indexes => :environment do
  Book.ensure_index [['title', 1]]
  Chapter.ensure_index [['book_id',1]]
  Chapter.ensure_index [['content',1]]
  Chapter.ensure_index [['rank',1]]
  
  Paragraph.ensure_index [['chapter_id',1]]
  Paragraph.ensure_index [['rank',1]]
  Paragraph.ensure_index [['content',1]]
  
  Sentence.ensure_index [['paragraph_id',1]]
  Sentence.ensure_index [['content',1]]
  Sentence.ensure_index [['rank',1]]
  
  Word.ensure_index [['Sentence',1]]
  Word.ensure_index [['content',1]]
  Word.ensure_index [['rank',1]]
end