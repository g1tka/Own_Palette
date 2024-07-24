require 'unicode'

module WordFilter
  extend self
  
  def load_ng_words(file_path)
    ng_words = []
    # ng_words.txtの各行ごとに取得するとメモリが少なくて済む。
    File.foreach(file_path) do |line|
      line.strip!
      ng_words << line unless line.empty?
    end
    
    ng_words
  end
  
  def filter_ng_words(text, ng_words)
    normalized_text = Unicode.nfkc(text)
    
    ng_words.each do |ng_word|
      # NGワードリストの各単語に対して、正規化を行う。
      normalized_ng_word = Unicode.nfkc(ng_word)
      # 正規化したテキストで、NGワードを***へ置換する。
      normalized_text.gsub!(normalized_ng_word, "☺☺☺")
    end
    
    normalized_text
  end
  
  def normalize_word(word)
    normalized_word = Unicode.nfkc(word)
    normalized_word = Unicode::Normalize.transliterate(normalized_word)
    normalized_word.downcase
  end
end