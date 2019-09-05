#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'

# require shared youtube-filer classes
require 'classes-youtube-filter'

# global arrays
$data_array = []

$all_file = []

# absolute path to the data dir.
data_directory = YoutubeFilter.base_directory("/Users/shadow_chaser/Code/Ruby/Projects/filter/scripts/data")

# create a new instance of category_data.
category_data = YoutubeFilter::CategoryStructure.new

#-----------------------------------------------------------------------------
# build the data
#-----------------------------------------------------------------------------
#
# pass in the location of the data directory containg all the datasets.
#
#
category_data.full_path_array(data_directory).each do |item|

    # new instance of CategoryStructure
    data = YoutubeFilter::CategoryStructure.new

    # split the path seperating the path after data and all sub directorys.
    path = item.split("data/")

    # split on / 
    dataset = path[1].split("/")

    # build the data struct 
    data.build_categorys(first: dataset[0], second: dataset[1], third: dataset[2], fourth: dataset[3],  full_path: item)

    # push each data struct containing a value to the array 
    if data.first.present? then $data_array.push(data) end

end

#-------------------------------------------------------------------------------
# Read in words
#-------------------------------------------------------------------------------
#
# This dataset is the words list that belong to each class of words. Each
# subtitle individual word will be referenced agaist each dataset, which is
# essentialy an array of words.
# Open the absolute file path, read in the list of words. Push each word to a
# string seperated by space then add the string of words to the datastruct finaly
# pushing each datastruct to the $all_file global array.
#
#

# Global Array
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
#
#-------------------------------------------------------------------------------
#
# build the initial category, FilterGroup WordGroup and PredicateGroup.
# As these are made so are the assosiations rank one and two.
# finaly adding each word to the individual categories
#
#
def build_rank_one(*args)
    if args[0].third == nil
        args[2].each do |word|
            args[1].constantize.find_or_create_by(category: args[0].second).datasets.find_or_create_by(word: word.squish)
        end
    end
end

$all_file.each do |struct|

  # split the words list into an array of words.
  words_array = struct.words_list.split

  #----------------------------------------------------------------------------
  # predicate group - 1 level, rank one
  #----------------------------------------------------------------------------
  mod_name = struct.first.capitalize + "GroupRankOne"

  # 
  build_rank_one(struct, mod_name, words_array)

  #----------------------------------------------------------------------------
  # filter group - 2 levels, rank one and rank two
  #----------------------------------------------------------------------------
  if struct.first == "filter" && struct.fourth == nil
      binding.pry
    FilterGroupRankOne.find_or_create_by(category: struct.second).filter_group_rank_twos.find_or_create_by(category: struct.third)

    words_array.each do |word|
      FilterGroupRankTwo.find_by(category: struct.third).datasets.find_or_create_by(word: word.squish)
    end
  end

  #----------------------------------------------------------------------------
  # submodalities group - 2 levels, rank one and rank two
  #----------------------------------------------------------------------------
  if struct.first == "submodalities" && struct.fourth == nil
    SubmodalitiesGroupRankOne.find_or_create_by(category: struct.second).submodalities_group_rank_twos.find_or_create_by(category: struct.third)

    words_array.each do |word|
      SubmodalitiesGroupRankTwo.find_by(category: struct.third).datasets.find_or_create_by(word: word.squish)
    end
  end

  #----------------------------------------------------------------------------
  # word group - 3 levels, rank one and rank two
  #----------------------------------------------------------------------------
  if struct.first == "word-group" && struct.fourth == nil
    WordGroupRankOne.find_or_create_by(category: struct.second).word_group_rank_twos.find_or_create_by(category: struct.third)

    words_array.each do |word|
      WordGroupRankTwo.find_by(category: struct.third).datasets.find_or_create_by(word: word.squish)
    end
  end

  if struct.first == "word-group" && struct.fourth != nil
      WordGroupRankOne.find_or_create_by(category: struct.second).word_group_rank_twos.find_or_create_by(category: struct.third)
      WordGroupRankTwo.find_by(category: struct.third).word_group_rank_threes.find_or_create_by(category: struct.fourth)

    words_array.each do |word|
      WordGroupRankThree.find_by(category: struct.fourth).datasets.find_or_create_by(word: word.squish)
    end
  end

end
