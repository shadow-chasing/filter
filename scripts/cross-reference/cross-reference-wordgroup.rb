#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)
require 'pry'
require 'classes-youtube-filter'

# word group title
@group_title = WordGroup.all.first.category

# retrive the datsets from the passed in rank category and pass in that array
# to the subtitle.where which takes an array returning the words that match.
def rank_collection(arg)
    @data = arg.datasets.pluck(:word)
    Subtitle.where(word: @data)
end

#-------------------------------------------------------------------------------
# rank one
#-------------------------------------------------------------------------------
#
# Produces all word_group_rank_one records without a word_group_rank_two_id,
# iterates over them then gets the dataset attached to the record. The dataset
# is then iterated over through the word_proccess method which creates the record.
#
#

WordGroupRankOne.all.each do |rank_one|
    rank_collection(rank_one).each do |word|
        unless word.word_group_results.find_by(rank_one: rank_one.category).present?

        word.word_group_results.find_or_create_by(group: @group_title, rank_one: rank_one.category)

        # find subtitle by id and update adding the category id for the
        # wordgroup category.
        word.update(category_id: YoutubeFilter::cat_id(:wordgroups))

      end
    end
end

#-------------------------------------------------------------------------------
# rank two
#-------------------------------------------------------------------------------
#
# Produces all word_group_rank_one with a word_group_rank_two_id, iterates over them
# gets the assosiated record via word_group_rank_twos, iterates over them then
# gets the dataset attached to the record. The dataset
# is then iterated over through the word_proccess method which creates the record.
#
#

WordGroupRankTwo.all.each do |rank_two|
    rank_collection(rank_two).each do |word|

        # rankone category
        rank_one = WordGroupRankOne.find_by(id: rank_two.word_group_rank_one_id)

        unless word.word_group_results.find_by(rank_one: rank_one.category, rank_two: rank_two.category).present?

            word.word_group_results.find_or_create_by(group: @group_title, rank_one: rank_one.category, rank_two: rank_two.category)

            # find subtitle by id and update adding the category id for the
            # wordgroup category.
            word.update(category_id: YoutubeFilter::cat_id(:wordgroups))

        end
    end
end

#-------------------------------------------------------------------------------
# rank three
#-------------------------------------------------------------------------------
#
# Produces all word_group_rank_one with a word_group_rank_two_id, iterates over them
# gets the assosiated record via word_group_rank_twos, iterates over them then
# gets the dataset attached to the record. The dataset
# is then iterated over through the word_proccess method which creates the record.
# 
#

WordGroupRankThree.all.each do |rank_three|
    rank_collection(rank_three).each do |word|

        # ranktwo category and id for rank one
        rank_two = WordGroupRankTwo.find_by(id: rank_three.word_group_rank_two_id)
        rank_one = WordGroupRankOne.find_by(id: rank_two.word_group_rank_one_id)

        unless word.word_group_results.find_by(rank_one: rank_one.category, rank_two: rank_two.category, rank_three: rank_three.category).present?

            word.word_group_results.find_or_create_by(group: @group_title, rank_one: rank_one.category, rank_two: rank_two.category, rank_three: rank_three.category)

            # find subtitle by id and update adding the category id for the
            # wordgroup category.
            word.update(category_id: YoutubeFilter::cat_id(:wordgroups))

        end
    end
end
