#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'

# base group title
@submodalities_title = SubmodalitiesGroup.first

# retrieve the datsets from the passed in rank category and pass in that array
# to the subtitle.where which takes an array returning the words that match.
def rank_collection(arg)
    @data = arg.submodalities_datasets.pluck(:word)
    Subtitle.where(word: @data)
end

#------------------------------------------------------------------------------
# FilterGRoupRankOne
#------------------------------------------------------------------------------
#
# Find all SubmodalitiesGroupRankOne records, pluck the words from the associated data
# set and pass them in to the Subtitle.where, this returns a collection of
# words contained in both lists then iterate over the individual words adding a
# SubmodalitiesGroupRecord containing group, rank_one and rank_two.
#
#
SubmodalitiesGroupRankOne.all.each do |rank_one|
    rank_collection(rank_one).each do |word|
      unless word.submodalities_group_results.present?

        # add results to the subtitle.submodalities_group_results assosiation.
        word.submodalities_group_results.find_or_create_by(group: @submodalities_title.category, rank_one: rank_one.category)

      end
    end
end

#------------------------------------------------------------------------------
# FilterGRoupRankTwo
#------------------------------------------------------------------------------
#
# Find all SubmodalitiesGroupRankTwo records, pluck the words from the associated data
# set and pass them in to the Subtitle.where, this returns a collection of
# words contained in both lists then iterate over the individual words adding a
# SubmodalitiesGroupRecord containing group, rank_one and rank_to.
#
#
SubmodalitiesGroupRankTwo.all.each do |rank_two|
    rank_collection(rank_two).each do |word|
      unless word.submodalities_group_results.present?

        # find the filter group rank one category name
        rank_one_title = SubmodalitiesGroupRankOne.find_by(id: rank_two.submodalities_group_rank_one_id).category

        # add results to the subtitle.submodalities_group_results assosiation.
        word.submodalities_group_results.find_or_create_by(group: @submodalities_title.category, rank_one: rank_one_title, rank_two: rank_two.category)

      end
    end
end
