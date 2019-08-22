#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'


# base group title
@filter_title = FilterGroup.first

#------------------------------------------------------------------------------
# FilterGRoupRankOne
#------------------------------------------------------------------------------
#
# Find all FilterGroupRankOne records, pluck the words from the assosiated data
# set and pass them in to the Subtitle.where, this returns a collection of
# words contained in both lists then iterate over the individual words adding a
# FilterGroupRecord containgin group, rank_one and rank_to.
#
#
FilterGroupRankOne.all.each do |rank_one|
    @data_one = rank_one.filter_datasets.pluck(:word)
    Subtitle.where(word: @data_one).each do |word|
      unless word.filter_group_results.present?

        # add results to the subtitle.filter_group_results assosiation.
        word.filter_group_results.find_or_create_by(group: @filter_title.category, rank_one: rank_one.category)

      end
    end
end

#------------------------------------------------------------------------------
# FilterGRoupRankTwo
#------------------------------------------------------------------------------
#
# Find all FilterGroupRankTwo records, pluck the words from the assosiated data
# set and pass them in to the Subtitle.where, this returns a collection of
# words contained in both lists then iterate over the individual words adding a
# FilterGroupRecord containgin group, rank_one and rank_to.
#
#
FilterGroupRankTwo.all.each do |rank_two|
    @data_two = rank_one.filter_datasets.pluck(:word)
    Subtitle.where(word: @data_two).each do |word|
      unless word.filter_group_results.present?

        # find the filter group rank one category name
        rank_one_title = FilterGroupRankOne.find_by(id: rank_two.filter_group_rank_one_id).category

        # add results to the subtitle.filter_group_results assosiation.
        word.filter_group_results.find_or_create_by(group: @filter_title.category, rank_one: rank_one_title, rank_two: rank_two.category)

      end
    end
end
