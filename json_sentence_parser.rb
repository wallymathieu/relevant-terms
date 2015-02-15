require_relative 'Sentence'

class JsonSentenceParser
  def initialize()
  end
  def normalize(json)
    json
      .gsub(/([a-z_]+):/, '"\1":')
      .gsub(/'([a-z]+)':/, '"\1":')
      .gsub(/:'([^']*)'/,':"\1"')
  end

  def parse(json)
    parsed = JSON.parse(normalize(json))
    return parsed.map { |d| 
      Sentence.json_create(d)
    }
  end
end

