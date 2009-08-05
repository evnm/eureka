# Eureka Invention Generator
# Copyright (C) 2009 Evan Meagher

# Licensed under the Open Software License 3.0
# Derivative works are allowed, but must themselves be licensed under OSL 3.0, and therefore the Source Code of those Derivative Works must be disclosed.


# File description: n-gram class definition. Stores list of leading words, hash of completions with frequencies, and an integer count of total completitions.

# More info on n-grams: http://en.wikipedia.org/wiki/N-gram


class Ngram

  attr_reader :leading_words, :total_completions, :completion_pairs

  def initialize(leading_words, completion)
    @leading_words = leading_words
    @total_completions = 1
    @completion_pairs = {completion => 1}
  end

  def add(completion)
    if @completion_pairs.has_key? completion then
      @completion_pairs[completion] += 1
    else
      @completion_pairs[completion] = 1
    end
    @total_completions += 1
    return self
  end

end