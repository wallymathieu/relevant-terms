#$KCODE = "UTF-8"
require 'test/unit'
require 'frequency'

class JsonSentencesParserTests < Test::Unit::TestCase
  def setup
    @parser = JsonSentencesParser.new()
    @frequencyCounter = FrequencyCounter.new()
  end
  
  def test1
    txt = "[{'text':'Ring Olle'},{'text':'Ring Daniel'}]"
    assert_equal "Ring Olle", @parser.parse(txt).first.text
  end
  
  def testCountFrequency
    txt = "[{'text':'Ring Olle'},{'text':'Ring Daniel'}]"
    words = @frequencyCounter.words( @parser.parse(txt).map{ |m| m.text })
    #puts @frequencyCounter.pretty_words( @parser.parse(txt).map{ |m| m.text })
    assert_equal({"Daniel"=>1, "Olle"=>1, "Ring"=>2},words)
  end
end

class FrequencyTests < Test::Unit::TestCase
  def setup
  end
  def testMarkovFrequency
    freq = Frequency.new(["Ring Olle och sådant","Ring Daniel med mera","Ring Per med flera","Ring Ylva och Lina"],2,2)
    puts freq.pretty_cache
  end
end