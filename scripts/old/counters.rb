#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'

# This method takes a given argument of a model name, loops through it and checks
# whether the word is contained within the Sub Table. If so it is added as a category
# based on the model name to the predicate column.

def sensory_predicate(model_name)
  model_name.all.each do |sub_word|
    if Sub.find_by(word: sub_word.word).present?
      my_word = Sub.find_by(word: sub_word.word)
      if my_word.predicate.nil?
        my_word.update(predicate: model_name.downcase)
      else
        my_word.update(secondary_predicate: model_name.downcase)
      end
    end
  end
end

def personality_counter(model_name)
  model_name.all.each do |sub_word|
    if Sub.find_by(word: sub_word.word).present?
      my_word = Sub.find_by(word: sub_word.word)
      my_word.update(personality: model_name.downcase)
    end
  end
end

def run
  sensory_predicate(Visual)
  sensory_predicate(Auditory)
  sensory_predicate(Kinesthic)
  sensory_predicate(Olfactory)
  sensory_predicate(Gustatory)

  personality_counter(Thinking)
  personality_counter(Feeling)
end

run
