#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'

#-------------------------------------------------------------------------------
# Subtitle
#-------------------------------------------------------------------------------

# word

# count all words
def self.lexicon_count(title)
  where(title: title).count
end

# average word size
def self.average_letters_per_word(title)
  where(title: title).average(:length)
end


# syllables

# sum all syllables
def self.syllable_total(title)
  where(title: title).pluck(:syllable).sum
end

# average syllable per word
def self.average_syllables_per_word(title)
  where(title: title).average(:syllable)
end


def sentance_count
end

def average_sentence
end

def paragraph_count

end
