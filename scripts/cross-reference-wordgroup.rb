#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'

#-------------------------------------------------------------------------------
# select level by rank one or two
#-------------------------------------------------------------------------------
# one: finds all WordGroupRankTwo records plucks the ids then passes them as an array
# to the WordGroupRankOne where not method.

# two: finds the WordGroupRankTwo records plucks the uniq ids generated from the group method
# then passes them to the where WordGroupRankOne id:
def word_group_ranks(option)
  case option
  when "one"
    return WordGroupRankOne.where.not(id: WordGroupRankTwo.group(:word_group_rank_one_id).pluck(:word_group_rank_one_id))
  when "two"
    return WordGroupRankOne.where(id: WordGroupRankTwo.group(:word_group_rank_one_id).pluck(:word_group_rank_one_id))
  end
end

#-------------------------------------------------------------------------------
# rank one
#-------------------------------------------------------------------------------
# Poduces all word_group_rank_one records without a word_group_rank_two_id,
# iterates over them then gets the dataset attached to the record. The dataset
# is then iterated over through the word_proccess method which creates the record.
# Subtitle.word_group_results

word_group_ranks("one").each do |results|
  results.word_datasets.each do |file_contents|
    Subtitle.where(word: file_contents.word).each do |word|
      unless Subtitle.find(word.id).word_group_results.present?
        group_title = WordGroup.find(results.word_group_id).category
        Category.find_or_create_by(name: :"word group").subtitles.find(word.id).word_group_results.find_or_create_by(group: group_title, rank_one: results.category)
      end
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
# Subtitle.word_group_results

word_group_ranks("two").each do |results|
  results.word_group_rank_twos.each do |sub_files|
    sub_files.word_datasets.each do |file_contents|
      Subtitle.where(word: file_contents.word).each do |word|
        unless Subtitle.find(word.id).word_group_results.present?
          group_title = WordGroup.find(results.word_group_id).category
          Category.find_or_create_by(name: :"word group").subtitles.find(word.id).word_group_results.find_or_create_by(group: group_title, rank_one: results.category, rank_two: sub_files.category)
        end
      end
    end
  end
end

# find any WordGroupResult with a rank_one: "categorys" and optinal argument.
def filter_results_for(arg)
  WordGroupResult.where(rank_one: :category_predicates).where(rank_two: arg)
end

def find_and_update_category(*args)
  filter_results_for(args[0]).each do |item|
    item.update(predicate: args[1])
  end
end

options = Hash.new
options[:color] = "visual"
options[:posative_feelings] = "kinesthetic"
options[:negative_feelings] = "kinesthetic"
options[:material] = "kinesthetic"
options[:qualaties_and_appearence] = "visual"
options[:shape] = "visual"
options[:size] = "visual"
options[:taste] = "olfactor"
options[:touch] = "kinesthetic"
options[:weather_and_temperature] = "kinesthetic"
options[:sound] = "bumbaclott"

# iterate over each key, value pair.
options.each do |k, v|
  find_and_update_category("#{k}", "#{v}")
end
