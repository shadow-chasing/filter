class Syntax < ApplicationRecord

  def self.paragraph_count
    last.count
  end

  def self.word_count
    count
  end

  def self.sentence_count
    select(:paragraph).group(:paragraph).count
  end

  

end
