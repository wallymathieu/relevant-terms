#$KCODE = "UTF-8"
require 'test/unit'
require_relative 'frequency'
class FrequencyTests < Test::Unit::TestCase
  def setup
  end
  def testEquality
    assert_equal [Token.new(:word,"word"),Token.new(:noise)],\
      [Token.new(:word,"word"),Token.new(:noise)]
  end
  def testEquality2
    assert_equal [Token.new(:word,"word"),Token.new(:noise),Token.new(:word,"word2")],\
      [Token.new(:word,"word"),Token.new(:noise),Token.new(:word,"word2")]
  end
  def testFrequency
    freq = Frequency.new(["Ring Olle och sådant","Ring Daniel med mera","Ring Per med flera","Ring Ylva och Lina"],3,3)
    puts freq.pretty_cache
  end
  def testFrequencyInStories
    lines =[]
    File.open("24117.txt", "r").readlines.each{ |line|
      line.split(/[\;\.\!\:]/).each{ |line| 
        l = line.strip.gsub(/,/,' ').gsub(/"/,' ')
        if l.length >0 && !l.match(/^\[/)
          lines.push(l)
        end
      }
    }
    
    #puts txt.gsub(/\n/, ' ')
    freq = Frequency.new(lines,4,4)
    puts freq.cache.select{ |key,value| value >4 }.sort_by{|key,value| value}.map{|key,value| sprintf("'%s': '%s'",key.join(" "),value) }.join("\n")
  end
end
