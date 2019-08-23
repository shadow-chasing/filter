#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'
require 'classes-youtube-filter'

#------------------------------------------------------------------------------
# sensory predicates
#------------------------------------------------------------------------------
#
# Get PredicateGroupRankOne attribute category by plucking category returning
# an array of just the category attribute values.
#
#
@sensory_predicate = PredicateGroupRankOne.all.pluck(:category)

# Iterate over each predicate. Use the individual predicate to retrive the
# PredicateGroupRankOne Dataset, pluck each word into an array and pass in the
# array of words to the Subitle.where which can take an array returning the
# matching words.
@sensory_predicate.each do |sense| 
    @word_collection = PredicateGroupRankOne.find_by(category: sense).predicate_datasets.pluck(:word)
    word_array = Subtitle.where(word: @word_collection)

    if word_array.present?
      word_array.each do |subtitle_word|

        subtitle_word.predicate_group_results.find_or_create_by(group: :"predicate-group", predicate: sense)

        # add the new category id to the specific predicate group
        subtitle_word.update(category_id: YoutubeFilter::cat_id(:predicates))

      end
    end
end

