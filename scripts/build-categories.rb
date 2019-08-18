#!/usr/bin/env ruby
$LOAD_PATH.push("/Users/shadow_chaser/Code/Ruby/Projects/filter/scripts")
require File.expand_path('../../config/environment', __FILE__)
require 'pry'

# require youtube-filter classes
require 'classes-category'

$data_array = []
$all_file = []

category_data = CategoryStructure.new

category_data.full_path_array("data").each do |item|

    # new instance of CategoryStructure
    data = CategoryStructure.new

    # split the path different data categorys.
    path = item.split("/")

    if path.count == 3
        data.build_categorys(first: path[1], second: path[2], third: path[3], full_path: item)
    elsif path.count == 4
        data.build_categorys(first: path[1], second: path[2], third: path[3], fourth: path[4], full_path: item)
    elsif path.count == 5
        data.build_categorys(first: path[1], second: path[2], third: path[3], fourth: path[4], fifth: path[5], full_path: item)
    end

    # push each data struct to the data array.
    $data_array << data

end

#-------------------------------------------------------------------------------
# predicate
#-------------------------------------------------------------------------------
$data_array.each do |struct|
    binding.pry
  if struct.first == "predicate-group"
      PredicateGroup.find_or_create_by(category: struct.second)
  end
end

#-------------------------------------------------------------------------------
# filter group
#-------------------------------------------------------------------------------
$data_array.each do |struct|
  if struct.first == "filter"
    FilterGroup.find_or_create_by(category: struct.second)
  end
end

#-------------------------------------------------------------------------------
# filter group rank one
#-------------------------------------------------------------------------------
$data_array.each do |struct|
  if struct.first == "filter" && struct.third != nil
    FilterGroupRankOne.find_or_create_by(category: struct.third)
    FilterGroup.find_by(category: struct.second).filter_group_rank_ones.find_or_create_by(category: struct.third)
  end
end

#-------------------------------------------------------------------------------
# filter group rank two
#-------------------------------------------------------------------------------
$data_array.each do |struct|
  if struct.first == "filter" && struct.fourth != nil
    FilterGroupRankTwo.find_or_create_by(category: struct.fourth)
    FilterGroupRankOne.find_by(category: struct.third).filter_group_rank_twos.find_or_create_by(category: struct.fourth)
  end
end


#-------------------------------------------------------------------------------
# word group
#-------------------------------------------------------------------------------
$data_array.each do |struct|
  if struct.first == "word-group"
    WordGroup.find_or_create_by(category: struct.second)
  end
end

#-------------------------------------------------------------------------------
# word group rank one
#-------------------------------------------------------------------------------
$data_array.each do |struct|
  if struct.first == "word-group" && struct.third != nil
    WordGroupRankOne.find_or_create_by(category: struct.third)
    WordGroup.find_by(category: struct.second).word_group_rank_ones.find_or_create_by(category: struct.third)
  end
end

#-------------------------------------------------------------------------------
# word group rank two
#-------------------------------------------------------------------------------
$data_array.each do |struct|
  if struct.first == "word-group" && struct.fourth != nil
    WordGroupRankTwo.find_or_create_by(category: struct.fourth)
    WordGroupRankOne.find_by(category: struct.third).word_group_rank_twos.find_or_create_by(category: struct.fourth)
  end
end

# --------end
#
#
#
#
#
#-------------------------------------------------------------------------------
# Get words from files and add to DirStruct
#-------------------------------------------------------------------------------
def neat(arg)
  arg.gsub(/(\[|\"|\\n|\\|\])/, "")
end

$per_file = []
$data_array.each do |item|
  File.foreach(item.full_path) do |line|
    $per_file << line
  end
  word_string = $per_file.to_s
  item.words_list = neat(word_string)
  $all_file << item
  $per_file.pop($per_file.count)
end

#-------------------------------------------------------------------------------
# predicate
#-------------------------------------------------------------------------------
$all_file.each do |struct|
  if struct.first == "predicate-group"
    struct.words_list.split(",").each do |word|
      PredicateGroup.find_or_create_by(category: struct.second).predicate_datasets.find_or_create_by(word: word.squish)
    end
  end
end

#-------------------------------------------------------------------------------
# filter group rank one
#-------------------------------------------------------------------------------
$all_file.each do |struct|
  if struct.first == "filter" && struct.third != nil
    struct.words_list.split(",").each do |word|
      FilterGroupRankOne.find_by(category: struct.third).filter_datasets.find_or_create_by(word: word.squish)
    end
  end
end

#-------------------------------------------------------------------------------
# filter word group rank two
#-------------------------------------------------------------------------------
$all_file.each do |struct|
  if struct.first == "filter" && struct.fourth != nil
    struct.words_list.split(",").each do |word|
      FilterGroupRankTwo.find_by(category: struct.fourth).filter_datasets.find_or_create_by(word: word.squish)
    end
  end
end
#-------------------------------------------------------------------------------
# word group rank one
#-------------------------------------------------------------------------------
$all_file.each do |struct|
  if struct.first == "word-group" && struct.third != nil
    struct.words_list.split(",").each do |word|
      WordGroupRankOne.find_by(category: struct.third).word_datasets.find_or_create_by(word: word.squish)
    end
  end
end

#-------------------------------------------------------------------------------
# word group rank two
#-------------------------------------------------------------------------------
$all_file.each do |struct|
  if struct.first == "word-group" && struct.fourth != nil
    struct.words_list.split(",").each do |word|
      WordGroupRankTwo.find_by(category: struct.fourth).word_datasets.find_or_create_by(word: word.squish)
    end
  end
end
