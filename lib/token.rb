
class Token
  attr_reader :tokentype,:word
  def initialize(tokentype,word='')
    @tokentype = tokentype
    @word = word
  end
  def to_s
    if @tokentype==:word
      return @word
    else
      return ":noise"
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
    if @tokentype == :noise # we know that the other token type is :noise
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
