#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'


#-------------------------------------------------------------------------------
# select level by rank one or two
#-------------------------------------------------------------------------------
# one: finds all filterGroupRankTwo records plucks the ids then passes them as an array
# to the filterGroupRankOne where not method.

# two: finds the filterGroupRankTwo records plucks the uniq ids generated from the group method
# then passes them to the where filterGroupRankOne id:
def filter_group_ranks(option)
  case option
  when "one"
    return FilterGroupRankOne.where.not(id: FilterGroupRankTwo.group(:filter_group_rank_one_id).pluck(:filter_group_rank_one_id))
  when "two"
    return FilterGroupRankOne.where(id: FilterGroupRankTwo.group(:filter_group_rank_one_id).pluck(:filter_group_rank_one_id))
  end
end

#-------------------------------------------------------------------------------
# rank one
#-------------------------------------------------------------------------------
# Poduces all filter_group_rank_one records without a filter_group_rank_two_id,
# iterates over them then gets the dataset attached to the record. The dataset
# is then iterated over through the filter_proccess method which creates the record.
# Subtitle.filter_group_results

filter_group_ranks("one").each do |results|
  results.filter_datasets.each do |file_contents|
    Subtitle.where(word: file_contents.word).each do |word|
      unless Subtitle.find(word.id).filter_group_results.present?
        group_title = FilterGroup.find(results.filter_group_id).category
        Category.find_or_create_by(name: :filter).subtitles.find(word.id).filter_group_results.find_or_create_by(group: group_title, rank_one: results.category)
      end
    end
  end
end

#-------------------------------------------------------------------------------
# rank two
#-------------------------------------------------------------------------------
# Poduces all filter_group_rank_one with a filter_group_rank_two_id, iterates over them
# gets the assosiated record via filter_group_rank_twos, iterates over them then
# gets the dataset attached to the record. The dataset
# is then iterated over through the filter_proccess method which creates the record.
# Subtitle.filter_group_results

filter_group_ranks("two").each do |results|
  results.filter_group_rank_twos.each do |sub_files|
    sub_files.filter_datasets.each do |file_contents|
      Subtitle.where(word: file_contents.word).each do |word|
        unless Subtitle.find(word.id).filter_group_results.present?
          group_title = FilterGroup.find(results.filter_group_id).category
          Category.find_or_create_by(name: :filter).subtitles.find(word.id).filter_group_results.find_or_create_by(group: group_title, rank_one: results.category, rank_two: sub_files.category)
        end
      end
    end
  end
end
