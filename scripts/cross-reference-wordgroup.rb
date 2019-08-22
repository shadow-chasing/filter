#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'
require 'classes-youtube-filter'

# TODO models have no belongs_to on PredicateGroupRankOne to the PredicateGroup
# RankTwo and RankOne no assosiation
#-------------------------------------------------------------------------------
# rank one
#-------------------------------------------------------------------------------
# Poduces all word_group_rank_one records without a word_group_rank_two_id,
# iterates over them then gets the dataset attached to the record. The dataset
# is then iterated over through the word_proccess method which creates the record.

WordGroupRankOne.all.each do |rank_one|
    @data_one = rank_one.word_datasets.pluck(:word)
    Subtitle.where(word: @data_one).each do |word|
      unless word.word_group_results.present?

        # word group title
        group_title = WordGroup.all.first.category

        word.word_group_results.find_or_create_by(group: group_title, rank_one: rank_one.category)

        # find subtitle by id and update adding the category id for the
        # wordgroup category.
        word.update(category_id: YoutubeFilter::cat_id(:wordgroups))

      end
    end
end

#-------------------------------------------------------------------------------
# rank two
#-------------------------------------------------------------------------------
# Poduces all word_group_rank_one with a word_group_rank_two_id, iterates over them
# gets the assosiated record via word_group_rank_twos, iterates over them then
# gets the dataset attached to the record. The dataset
# is then iterated over through the word_proccess method which creates the record.

WordGroupRankTwo.all.each do |rank_two|
    @data_two = rank_two.word_datasets.pluck(:word)
    Subtitle.where(word: @data_two).each do |word|
      unless word.word_group_results.present?

        # word group title
        group_title = WordGroup.all.first.category

        # rankone category
        rank_one_title = WordGroupRankOne.find_by(id: rank_two.word_group_rank_one_id).category

        word.word_group_results.find_or_create_by(group: group_title, rank_one: rank_one_title, rank_two: rank_two.category)

        # find subtitle by id and update adding the category id for the
        # wordgroup category.
        word.update(category_id: YoutubeFilter::cat_id(:wordgroups))

      end
    end
end
