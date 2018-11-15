
class Token
  attr_reader :tokentype,:word
  attr_accessor :count
  def initialize(tokentype,word='')
    @tokentype = tokentype
    @word = word
    @count = 1
  end
  def to_s
    if @tokentype==:word
      return @word
    else
      return ":noise #{@count}"
    end
  end
  def noise?
    return @tokentype==:noise
  end
  def ==(other_token)
    if nil==other_token
      return false
    end
    if @tokentype!=other_token.tokentype
      return false
    end
    if @tokentype == :noise
      return true
    end
    if @tokentype == :word
      return @word == other_token.word
    end
    raise "Unexpected tokentype #{@tokentype}"
  end
  def to_key
    if @tokentype==:word
      return @word
    else
      return ":noise"
    end
  end
end
