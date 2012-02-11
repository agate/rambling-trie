module Rambling
  module TrieBranches
    def has_branch_for?(word)
      word.empty? or branch_exists_and(word, :has_branch_for?)
    end

    def is_word?(word = '')
      (word.empty? and terminal?) or branch_exists_and(word, :is_word?)
    end

    def add_branch_from(word)
      raise InvalidTrieOperation.new('Cannot add branch to compressed trie') if compressed?
      return if word.empty?

      first_letter = word.slice(0).to_sym

      if @children.has_key?(first_letter)
        word.slice!(0)
        @children[first_letter].add_branch_from(word)
      else
        @children[first_letter] = TrieNode.new(word, self)
      end
    end

    private

    def branch_exists_and(word, method)
      return false if word.empty?

      first_letter = word.slice!(0)

      return false if first_letter.nil?

      first_letter_key = first_letter.to_sym
      @children.has_key?(first_letter_key) ? @children[first_letter_key].send(method, word) : false
    end
  end
end
