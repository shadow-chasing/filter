#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'

# require shared youtube-filer classes
require 'classes-youtube-filter'

$data_array = []
$all_file = []

# absolute path to the data dir.
data_directory = YoutubeFilter.base_directory("/Users/shadow_chaser/Code/Ruby/Projects/filter/scripts/data")

# create a new instance of category_data.
category_data = YoutubeFilter::CategoryStructure.new

#-----------------------------------------------------------------------------
# build the data
#-----------------------------------------------------------------------------

# pass in the location of the data directory containg all the datasets.
category_data.full_path_array(data_directory).each do |item|

    # new instance of CategoryStructure
    data = YoutubeFilter::CategoryStructure.new

    # split the path seperating the path after data and all sub directorys.
    path = item.split("data/")

    # split on / 
    dataset = path[1].split("/")

    # build the data struct 
    data.build_categorys(first: dataset[0], second: dataset[1], third: dataset[2], four: dataset[3],  full_path: item)

    # push each data struct containing a value to the array 
    if data.first.present? then $data_array.push(data) end

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
# build the initial category, FilterGroup WordGroup and PredicateGroup.
# As these are made so are the assosiations rank one and two.
# finaly adding each word to the individual categories
#-------------------------------------------------------------------------------
$all_file.each do |struct|

  words_array = struct.words_list.split

  if struct.first == "predicate-group"

    words_array.each do |word|
      PredicateGroup.find_or_create_by(category: struct.second).predicate_datasets.find_or_create_by(word: word.squish)
    end
  end

  if struct.first == "filter" && struct.second != nil
    FilterGroup.find_or_create_by(category: struct.first).filter_group_rank_ones.find_or_create_by(category: struct.second)

    words_array.each do |word|
      FilterGroupRankOne.find_by(category: struct.second).filter_datasets.find_or_create_by(word: word.squish)
    end
  end

  if struct.first == "filter" && struct.third != nil
    FilterGroupRankOne.find_or_create_by(category: struct.second).filter_group_rank_twos.find_or_create_by(category: struct.third)

    words_array.each do |word|
      FilterGroupRankTwo.find_by(category: struct.third).filter_datasets.find_or_create_by(word: word.squish)
    end
  end

  if struct.first == "word-group" && struct.second != nil
    WordGroup.find_or_create_by(category: struct.first).word_group_rank_ones.find_or_create_by(category: struct.second)

    words_array.each do |word|
      WordGroupRankOne.find_by(category: struct.second).word_datasets.find_or_create_by(word: word.squish)
    end

  end

  if struct.first == "word-group" && struct.third != nil
    WordGroupRankOne.find_or_create_by(category: struct.second).word_group_rank_twos.find_or_create_by(category: struct.third)

    words_array.each do |word|
      WordGroupRankTwo.find_by(category: struct.third).word_datasets.find_or_create_by(word: word.squish)
    end
  end

end
