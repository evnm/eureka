# Eureka Invention Generator
# Copyright (C) 2009 Evan Meagher

# Licensed under the Open Software License 3.0
# Derivative works are allowed, but must themselves be licensed under OSL 3.0, and therefore the Source Code of those Derivative Works must be disclosed.


# File description: Generates a binary tree of ngrams from corpus of source text. Uses tree to generate text.

# Certain variables within the generate_invention method control the nature of the textual output:
#   window_size: Size of Markov "window" used to construct ngrams
#   word_count: Approximate word count of the output text


require "ngram.rb"
require "ngram_btree_node.rb"

def generate_invention(window_size=3, word_count=80)
  # randomly select file within corpus directory
  file = "corpus/" + rand(Dir.entries("corpus").size - 2).to_s + ".txt"
  tree = build_tree(window_size, file)
  list = build_list(word_count, tree)
  return list*" "
end


private

def insert(tree, leading_words, completion)
  if tree.nil? then
    tree = Node.new(Ngram.new(leading_words, completion), nil, nil)
  elsif (leading_words <=> tree.ngram.leading_words) == -1 then
    tree.left = insert(tree.left, leading_words, completion)
  elsif (leading_words <=> tree.ngram.leading_words) == 1 then
    tree.right = insert(tree.right, leading_words, completion)
  else
    tree.ngram = tree.ngram.add(completion)
  end
  return tree
end


def insert_list(lst)
  root = nil
  lst.each do |words|
    root = insert(root, words[0..words.length - 2], words.last)
  end
  return root
end


def find(leading_words, tree)
  if tree.nil? then
    return nil
  elsif (leading_words <=> tree.ngram.leading_words) == -1 then
    return find(leading_words, tree.left)
  elsif (leading_words <=> tree.ngram.leading_words) == 1 then
    return find(leading_words, tree.right)
  else
    return tree.ngram
  end
end


def group_words(n, lst)
  result = Array.new
  (lst.length - n + 1).times do |index|
    result << lst.slice(index, n)
  end
  return result
end

def pick_random(tree)
  caps = get_caps(tree)
  return caps[rand(caps.length)]
end


def random_word(ngram)
  index = rand(srand) % ngram.total_completions
  return get_completions_list(ngram.completion_pairs)[index]
end


def build_tree(n, filename)
  return insert_list(group_words(n, file_to_array(filename)))
end


def build_list(count, tree)
  starting_words = pick_random(tree)
  result = [starting_words[0]]
  return shift(result, starting_words, count - starting_words.length, tree)
end


### Helper methods

# pick_random helper: Creates array of leading words with capitalized first word.
def get_caps(tree)
  if tree.nil? then
    return []
  elsif tree.ngram.leading_words[0] == tree.ngram.leading_words[0].capitalize then
    return [tree.ngram.leading_words] + get_caps(tree.left) + get_caps(tree.right)
  else
    return get_caps(tree.left) + get_caps(tree.right)
  end
end


# random_word helper
def get_completions_list(completion_pairs)
  result = Array.new
  completion_pairs.each do |k,v|
    v.times do
      result.push k
    end
  end
  return result
end


# build_tree helper: returns list of tokens from file
def file_to_array(filename)
  file = File.new(filename)
  lines = file.to_a
  lines.each do |line|
    line.strip!
  end
  lines.reject! do |line|
    line.length == 0
  end
  lines.collect! do |line|
    line.split
  end
  return lines.flatten
end


# build_list helpers
def shift(result, current_words, count, tree)
  current_ngram = find(current_words, tree)
  if current_ngram.nil? then
    return result + current_words.slice(1..-1)
  elsif count.zero? then
    current_words = current_words.slice(1..-1) << random_word(current_ngram)
    return shift_until_sentence_end(result << current_words[0], current_words, tree)
  else
    current_words = current_words.slice(1..-1) << random_word(current_ngram)
    return shift(result << current_words[0], current_words, count - 1, tree)
  end
end

def shift_until_sentence_end(result, current_words, tree)
  current_ngram = find(current_words, tree)
  re = Regexp.new('[.|!|?]$')
  if current_ngram.nil? then
    return result + current_words.slice(1..-1)
  elsif re.match(current_words[0]) then
    return result
  else
    current_words = current_words.slice(1..-1) << random_word(current_ngram)
    return shift_until_sentence_end(result << current_words[0], current_words, tree)
  end
end