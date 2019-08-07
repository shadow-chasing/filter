class Word < ApplicationRecord
  belongs_to :node


  # count all words
  def self.lexicon_count(title)
    where(title: title).count
  end

  # average word size
  def self.average_letters_per_word(title)
    where(title: title).average(:length)
  end


end
