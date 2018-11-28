require_relative 'token'

def get_words(txt)
  return txt.split(" ")
end

class Frequency
  # inspired by markov chains
  
  def initialize(sentences, min_frequence_word_interest=2, max_gram_length=7)
    @sentences = sentences.map{ |s| s.downcase }
    @min_frequence_word_interest = min_frequence_word_interest
    @max_gram_length = max_gram_length
  end
  def pretty_triples_freq()
    return triples_freq().map{|key,value| sprintf("'%s': %s",key.join(" "),value) }.join("\n")
  end
  
  def triples()
  # """ Generates triples from the given data string. So if our string were
  #     "What a lovely day", we'd generate (What, a, :noise) 
  #     if lovely is not present so often.
  # """
    words_of_interest = @sentences.map { |sentence| get_words sentence }
      .flatten
      .group_by { |word| word }
      .map { |word,grp| [word,grp.length] }
      .select{ |key,value| value>=@min_frequence_word_interest}
      .map{ |key,value| key }
    interesting_sentences = @sentences.select{ |sentence| 
      get_words(sentence).select{ |w| words_of_interest.include?(w) }.count>0
    }
    retval = []
    interesting_sentences.each{ |sentence|
      words = get_words(sentence)
      for i in (0 .. words.length-2)
        ws=[]
        j=0
        last = nil
        # the attention span of an average person is supposedly 
        # ca 7 entities, thus lets use that for reference 
        while ws.length < @max_gram_length && i+j<words.length
          w = words[i+j]
          if words_of_interest.include?(w)
            t = Token.new(:word,w)
          else
            t = Token.new(:noise)
          end
          # glob together noise words
          if ( last==nil || !last.noise? || !t.noise?)
            ws.push(t)
            last=t
          end
          j +=1
        end
        # filter out noise only lines
        if ws.select {|w| !w.noise? }.count>0
          retval.push( ws )
        end
      end
    }

    return retval
  end
  def triples_freq()
    triples()
      .group_by{ |arr| arr.map &:to_key }
      .map{ |k,v| [k,v.length] }
  end
end

if __FILE__==$0
  lines =[]
  File.open(ARGV[0], "r").readlines.each{ |line|
    l = line.strip.gsub(/,/,' ').gsub(/"/,' ').gsub(/[_-]/,' ')
    if l.length >0 && !l.match(/^\[/)
      lines.push(l)
    end
  }

  freq = Frequency.new(lines,4)
  puts freq.triples_freq().select{ |key,value| value >4 }.sort_by{|key,value| value}.map{|key,value| sprintf("'%s': '%s'",key.join(" "),value) }.join("\n")
end
