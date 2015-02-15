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

