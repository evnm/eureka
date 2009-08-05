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