require 'test/unit'
require_relative 'json_sentence_parser'
require_relative 'frequency'

class JsonSentenceParserTests < Test::Unit::TestCase
  def setup
    @parser = JsonSentenceParser.new()
    @frequencyCounter = FrequencyCounter.new()
  end
  
  def test_parse_sample_string
    txt = "[{'text':'Ring Olle'},{'text':'Ring Daniel'}]"
    assert_equal "Ring Olle", @parser.parse(txt).first.text
  end
  
  def test_count_frequency
    txt = "[{'text':'Ring Olle'},{'text':'Ring Daniel'}]"
    words = @frequencyCounter.words( @parser.parse(txt).map{ |m| m.text })
    #puts @frequencyCounter.pretty_words( @parser.parse(txt).map{ |m| m.text })
    assert_equal({"Daniel"=>1, "Olle"=>1, "Ring"=>2},words)
  end
end

