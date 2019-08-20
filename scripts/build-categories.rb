#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'

# require classes-youtube-filter
require 'classes-youtube-filter'

$data_array = []
$all_file = []

# absolute path to the data dir.
data_directory = "/Users/shadow_chaser/Code/Ruby/Projects/filter/scripts/data"

# create a new instance of category_data.
category_data = YoutubeFilter::CategoryStructure.new

#-----------------------------------------------------------------------------
#
#-----------------------------------------------------------------------------
# pass in the location of the data directory containg all the datasets.
category_data.full_path_array(data_directory).each do |item|

    # new instance of CategoryStructure
    data = YoutubeFilter::CategoryStructure.new

    # split the path seperating the path after data and all sub directorys.
    path = item.split("data/")

    # split on / 
    dataset = path[1].split("/")

    case dataset.count
      when 1
        data.build_categorys(first: dataset[0], full_path: item)
      when 2
        data.build_categorys(first: dataset[0], second: dataset[1], full_path: item)
      when 3
        data.build_categorys(first: dataset[0], second: dataset[1], third: dataset[2],  full_path: item)
      end

    # push each data struct containing a value to the data array 
    if data.first.present? then $data_array.push(data) end

end

#-------------------------------------------------------------------------------
# predicate, filter and wordgroup
#-------------------------------------------------------------------------------
$data_array.each do |struct|

  if struct.first == "predicate-group"
    PredicateGroup.find_or_create_by(category: struct.second)
  elsif struct.first == "filter"
    FilterGroup.find_or_create_by(category: struct.second)
  elsif struct.first == "word-group"
    WordGroup.find_or_create_by(category: struct.second)
  end

end

#-------------------------------------------------------------------------------
# 
#-------------------------------------------------------------------------------
$data_array.each do |struct|

  if struct.first == "filter" && struct.third != nil
    FilterGroupRankOne.find_or_create_by(category: struct.third)
    FilterGroup.find_by(category: struct.second).filter_group_rank_ones.find_or_create_by(category: struct.third)

  elsif struct.first == "filter" && struct.fourth != nil
    FilterGroupRankTwo.find_or_create_by(category: struct.fourth)
    FilterGroupRankOne.find_by(category: struct.third).filter_group_rank_twos.find_or_create_by(category: struct.fourth)


  elsif struct.first == "word-group" && struct.third != nil
    WordGroupRankOne.find_or_create_by(category: struct.third)
    WordGroup.find_by(category: struct.second).word_group_rank_ones.find_or_create_by(category: struct.third)

  elsif struct.first == "word-group" && struct.fourth != nil
    WordGroupRankTwo.find_or_create_by(category: struct.fourth)
    WordGroupRankOne.find_by(category: struct.third).word_group_rank_twos.find_or_create_by(category: struct.fourth)
  end

end

#-------------------------------------------------------------------------------
# Get words from files and add to DirStruct
#-------------------------------------------------------------------------------
$per_file = []

# iterate over each ablolute path file.
$data_array.each do |item|

  File.foreach(item.full_path) do |line|
      $per_file << line.chomp
  end

  # create an empty string to avoid the string being created localy in the each
  # loop.
  list = ""

  # iterate over the $per_file array appending each word to the list.
  $per_file.each {|word| list << "#{word} " }

  # add list to the word list.
  item.words_list = list

  # append each item to the all_file array then pop all items in the per_file
  # array by how many item are in it.
  $all_file << item

  $per_file.pop($per_file.count)

end

#-------------------------------------------------------------------------------
# Add each word to the individual categories
#-------------------------------------------------------------------------------
$all_file.each do |struct|

  if struct.first == "predicate-group"
    struct.words_list.split(",").each do |word|
      PredicateGroup.find_or_create_by(category: struct.second).predicate_datasets.find_or_create_by(word: word.squish)
    end

  elsif struct.first == "filter" && struct.third != nil
    struct.words_list.split(",").each do |word|
      FilterGroupRankOne.find_by(category: struct.third).filter_datasets.find_or_create_by(word: word.squish)
    end

  elsif struct.first == "filter" && struct.fourth != nil
    struct.words_list.split(",").each do |word|
      FilterGroupRankTwo.find_by(category: struct.fourth).filter_datasets.find_or_create_by(word: word.squish)
    end
  elsif struct.first == "word-group" && struct.third != nil
    struct.words_list.split(",").each do |word|
      WordGroupRankOne.find_by(category: struct.third).word_datasets.find_or_create_by(word: word.squish)
    end

  elsif struct.first == "word-group" && struct.fourth != nil
    struct.words_list.split(",").each do |word|
      WordGroupRankTwo.find_by(category: struct.fourth).word_datasets.find_or_create_by(word: word.squish)
    end
  end

end
