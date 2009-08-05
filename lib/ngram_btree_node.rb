class Node

  attr_accessor :ngram, :left, :right

  def initialize(ngram=nil, left=nil, right=nil)
    @ngram, @left, @right = ngram, left, right
  end

end