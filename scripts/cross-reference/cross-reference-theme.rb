#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)
require 'pry'

# base group title
@theme_title = ThemeGroup.first

# retrieve the datsets from the passed in rank category and pass in that array
# to the subtitle.where which takes an array returning the words that match.
def rank_collection(arg)
    @data = arg.datasets.pluck(:word)
    Subtitle.where(word: @data)
end

#------------------------------------------------------------------------------
# ThemeGRoupRankOne
#------------------------------------------------------------------------------
#
# Find all ThemeGroupRankOne records, pluck the words from the associated data
# set and pass them in to the Subtitle.where, this returns a collection of
# words contained in both lists then iterate over the individual words adding a
# ThemeGroupRecord containing group, rank_one and rank_two.
#
#
ThemeGroupRankOne.all.each do |rank_one|
    rank_collection(rank_one).each do |word|
      unless word.theme_group_results.present?
          binding.pry

        # add results to the subtitle.theme_group_results assosiation.
        word.theme_group_results.find_or_create_by(group: @theme_title.category, rank_one: rank_one.category)

      end
    end
end

#------------------------------------------------------------------------------
# ThemeGRoupRankTwo
#------------------------------------------------------------------------------
#
# Find all ThemeGroupRankTwo records, pluck the words from the associated data
# set and pass them in to the Subtitle.where, this returns a collection of
# words contained in both lists then iterate over the individual words adding a
# ThemeGroupRecord containing group, rank_one and rank_to.
#
#
ThemeGroupRankTwo.all.each do |rank_two|
    rank_collection(rank_two).each do |word|
      unless word.theme_group_results.present?

        # find the theme group rank one category name
        rank_one_title = ThemeGroupRankOne.find_by(id: rank_two.theme_group_rank_one_id).category

        # add results to the subtitle.theme_group_results assosiation.
        word.theme_group_results.find_or_create_by(group: @theme_title.category, rank_one: rank_one_title, rank_two: rank_two.category)

      end
    end
end
