require "rubygems"
require "json/pure"
class Sentence
  attr_reader :text
  def initialize(text)
    @text = text
  end
  def to_json(*a)
    {
      "text"         => @text
    }.to_json(*a)
  end
 
  def self.json_create(o)
    new(o["text"])
  end
end

class JsonSentencesParser
  def initialize()
  end
  
  def parse(json)
    parsed = JSON.parse(json.gsub(/([a-z_]+):/, '"\1":').gsub(/'([a-z]+)':/, '"\1":').gsub(/:'([^']*)'/,':"\1"'))
    return parsed.map { |d| 
      Sentence.json_create(d)
    }
  end
end

def getWords(txt)
  return txt.split(" ")
end

class FrequencyCounter
  def words(sentences)
    words={}
    sentences.each{ |sentence| getWords(sentence)\
      .each{ |w| if words.key?(w) then words[w]=words[w]+1 else words[w]=1 end } }
    return words
  end
  def pretty_words(sentences)
    return self.words(sentences).sort{|x,y| x[1]<=>y[1] }.map{|key,value| sprintf("%s: %d",key,value) }.join("\n")
  end
end
class Token
  attr_reader :type,:word
  attr :count
  def initialize(type,word='')
    @type = type
    @word = word
    @count = 1
  end
  def to_s
    if @type==:word
      return @word
    else
      return ":noise #{@count}"
    end
  end
  def noise?
    return @type==:noise
  end
end
class Frequency
  # inspired by markov chains
  attr_reader :cache
  
  def initialize(sentences, min_frequence_word_interest=2, max_frequency_noise_word=2)
    @frequencyCounter = FrequencyCounter.new
    @cache = {}
    @sentences = sentences 
    @min_frequence_word_interest = min_frequence_word_interest
    @max_frequency_noise_word = max_frequency_noise_word
    database()
  end
  def pretty_cache()
    return @cache.map{|key,value| sprintf("'%s': '%s'",key.join(" "),value.join("=")) }.join("\n")
  end
  #def file_to_words()
  # words = data.split(" ")
  # return words
  #end
  
  def triples()
  # """ Generates triples from the given data string. So if our string were
  #     "What a lovely day", we'd generate (What, a, lovely) and then
  #     (a, lovely, day).
  # """
    words_of_interest = @frequencyCounter.words(@sentences)\
      .select{ |key,value| value>=@min_frequence_word_interest}\
      .map{ |key,value| key }
    interesting_sentences = @sentences.select{ |sentence| 
      getWords(sentence).select{ |w| words_of_interest.include?(w) }.count>0
    }
    retval = []
    #retval.push([{:token=>:word, :text=>'Ring'},{:token=>:noise},{:token=>:word,:test=>'på'}]
    
    interesting_sentences.each{ |sentence|
      words = getWords(sentence)
      for i in (0 .. words.length - 2)
        ws=[]
        j=0
        last = nil
        while ws.length <3 and i+j<=words.length
          w = words[i+j]
          if words_of_interest.include?(w)
            t = Token.new(:word,w)
          else
            t = Token.new(:noise)
          end
          if (last!=nil and last.noise? and t.noise?)
            last.count +=1
          else
            ws.push(t)
          end
          j +=1
        end
        retval.push( ws )
      end
    }

    return retval
  end
      
  def database()
    for w1, w2, w3 in triples()
      key = [w1, w2]
      #if [w1,w2,w3].select{|w| not w.noise? }.count>0
        
        if @cache.key?(key) then
          @cache[key].push(w3)
        else
          @cache[key] = [w3]
        end
      #end
    end
  end
        
  def generate_markov_text(size=25)
    seed = rand(@word_size-3)
    seed_word, next_word = @words[seed], @words[seed+1]
    w1, w2 = seed_word, next_word
    gen_words = []
    for i in (0..size)
      gen_words.push(w1)
      choice = @cache[[w1, w2]]
      if nil != choice
        w1, w2 = w2, choice[rand(choice.length)]
      end
    end
    gen_words.push(w2)
    return gen_words.join(" ")
  end
end   

