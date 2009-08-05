# Eureka Invention Generator
# Copyright (C) 2009 Evan Meagher

# Licensed under the Open Software License 3.0
# Derivative works are allowed, but must themselves be licensed under OSL 3.0, and therefore the Source Code of those Derivative Works must be disclosed.


# File description: binary tree of n-grams class definition.


class Node

  attr_accessor :ngram, :left, :right

  def initialize(ngram=nil, left=nil, right=nil)
    @ngram, @left, @right = ngram, left, right
  end

end