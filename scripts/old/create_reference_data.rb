#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'

# initial word list must have been created.

class CompList

  def initialize(file)
    @file = file
    @arry = Array.new
  end

  # open file of words and generate and array.
  def words_list(file)
      File.foreach(file) do |line|
         @arry << line.chomp
      end
  end

  def build_db(arg)
    # generate an array of words from a given text file.
    words_list(@file)

    # iterate over the array creating a word entrie in the db.
    @arry.each do |w|
        arg.find_or_create_by(word: w)
    end

    # clear the array
    @arry.pop(@arry.count)
  end

  # This method takes a given argument of a model name, loops through it and checks
  # whether the word is contained within the Sub Table. If so it is added as a category
  # based on the model name to the predicate column.

  def sensory_predicate(model_name)
    model_lower = model_name.to_s
    model_name.all.each do |sub_word|
      if Sub.find_by(word: sub_word.word).present?
        my_word = Sub.find_by(word: sub_word.word)
        if my_word.predicate.nil?
          my_word.update(predicate: model_lower.downcase)
        else
          my_word.update(secondary_predicate: model_lower.downcase)
        end
      end
    end
  end

  def personality_counter(model_name)
    model_lower = model_name.to_s
    model_name.all.each do |sub_word|
      if Sub.find_by(word: sub_word.word).present?
        my_word = Sub.find_by(word: sub_word.word)
        my_word.update(personality: model_lower.downcase)
      end
    end
  end

end

#------------------------------------------------------------------------------
# Create comparison data
#------------------------------------------------------------------------------
comparison = CompList.new("sensory-predicates/visual.txt")
comparison.build_db(Visual)
comparison.sensory_predicate(Visual)

comparison = CompList.new("sensory-predicates/auditory.txt")
comparison.build_db(Auditory)
comparison.sensory_predicate(Auditory)

comparison = CompList.new("sensory-predicates/kinesthic.txt")
comparison.build_db(Kinesthic)
comparison.sensory_predicate(Kinesthic)

comparison = CompList.new("sensory-predicates/olfactory.txt")
comparison.build_db(Olfactory)
comparison.sensory_predicate(Olfactory)

comparison = CompList.new("sensory-predicates/gustatory.txt")
comparison.build_db(Gustatory)
comparison.sensory_predicate(Gustatory)

comparison = CompList.new("personality/thinking.txt")
comparison.build_db(Thinking)
comparison.personality_counter(Thinking)

comparison = CompList.new("personality/feeling.txt")
comparison.build_db(Feeling)
comparison.personality_counter(Feeling)
