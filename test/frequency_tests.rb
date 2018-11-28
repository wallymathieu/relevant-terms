#$KCODE = "UTF-8"
require 'test/unit'
require_relative '../lib/frequency'
class FrequencyTests < Test::Unit::TestCase
  def setup
  end
  def test_frequency
    freq = Frequency.new(["Ring Olle och sådant","Ring Daniel med mera","Ring Per med flera","Ring Ylva och Lina"],3)
    puts freq.pretty_triples_freq()
  end
  def test_frequency_in_stories
    lines = File.open("test/24117.txt", "r").readlines
      .map {|line| line.split(/[\;\.\!\:]/)}
      .flatten
      .map {|line| line.strip.gsub(/,/,' ').gsub(/"/,' ')}
      .select{ |line| line.length >0 && !line.match(/^\[/) }

    #puts txt.gsub(/\n/, ' ')
    freq = Frequency.new(lines,4)
    expected = ["'the :noise': 21",
                "'a :noise': 14",
                "':noise and :noise': 9",
                "'her :noise': 8",
                "':noise the :noise': 7",
                "'and :noise': 7",
                "':noise the': 7",
                "'to :noise': 6",
                "'was :noise': 6",
                "':noise in the :noise': 5",
                "'very :noise': 5",
                "':noise to :noise': 5",
                "':noise and': 5"
                ].join("\n")
    terms = freq.triples_freq()
                      .select{ |key,value| value >4 }
                      .sort_by{|key,value| value}.reverse!
                      .map{|key,value| sprintf("'%s': %s",key.join(" "),value) }
                      .join("\n")
    assert_equal(expected, terms)
  end
end
