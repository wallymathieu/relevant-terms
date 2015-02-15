
class FrequencyCounter
  def words(sentences)
    words={}
    sentences.each{ |sentence| get_words(sentence)\
      .each{ |w| if words.key?(w) then words[w]=words[w]+1 else words[w]=1 end } }
    return words
  end
  def pretty_words(sentences)
    return self.words(sentences).sort{|x,y| x[1]<=>y[1] }\
      .map{|key,value| sprintf("%s: %d",key,value) }.join("\n")
  end
end

