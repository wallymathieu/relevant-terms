require 'test/unit'
require_relative '../lib/token'
class TokenTests < Test::Unit::TestCase
  def test_equality
    assert_equal [Token.new(:word,"word"),Token.new(:noise)],\
      [Token.new(:word,"word"),Token.new(:noise)]
  end

  def test_equality_2
    assert_equal [Token.new(:word,"word"),Token.new(:noise),Token.new(:word,"word2")],\
      [Token.new(:word,"word"),Token.new(:noise),Token.new(:word,"word2")]
  end
end


