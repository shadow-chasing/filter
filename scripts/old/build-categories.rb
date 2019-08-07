#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'

#-------------------------------------------------------------------------------
# This group builds the categories of each model: lines 84 - 157
#-------------------------------------------------------------------------------
# ModalityGroups:             lines 86-90
# PersonalityGroup:           lines 94-98
# PredicateGroup:             lines 102-106
# WordGroup - level 1 and 2:  lines 122-157

#-------------------------------------------------------------------------------
# Two methods that add a datastruct to an array: lines 170-209
#-------------------------------------------------------------------------------
# create_array_of_file_info:  lines 170-192
# get_words_from_file:        lines 198-208

#-------------------------------------------------------------------------------
# build the database:         lines 210-305
#-------------------------------------------------------------------------------
# build_db_word_group:        lines 222-241
# build_db_modality_group:    lines 247-264
# build_db_predicate_group:   lines 266-283
# build_db_personality_group: lines 285-302
#-------------------------------------------------------------------------------
# Global Arrays
#-------------------------------------------------------------------------------
$arry = []
$has_sub_dir = []
$dir_array = []
$info = []
$per_file = []
$all_file = []
$word = ["noun", "verb",	"adjective", "pronoun", "conjunction"]
#-------------------------------------------------------------------------------
# classes
#-------------------------------------------------------------------------------
class DataStruct
  attr_accessor :model_group, :category, :full_path, :words_list

  def attributes(args={})
    @model_group = args[:model_group]
    @category = args[:category]
    @full_path = args[:full_path]
    @words_list = args[:words_list]
  end
end

#-------------------------------------------------------------------------------
# helpers
#-------------------------------------------------------------------------------
def strip_junk(arg)
  remove = [",", ".", "?", "!", ":", "/"]
  remove.each do |char|
    if arg.include?(char)
      return arg.chomp(char)
    end
  end
  return arg
end

def green(mytext) ; "\e[32m#{mytext}\e[0m" ; end
def blue(mytext) ; "\e[36m#{mytext}\e[0m" ; end
def red(mytext) ; "\e[31m#{mytext}\e[0m" ; end

#-------------------------------------------------------------------------------
# methods
#-------------------------------------------------------------------------------
# creates and array of absolute filepaths.
def file_array(arg)
  Dir.glob("#{arg}/**/*").select{ |f| File.file? f }
end

# NOTE: use a if statment to test wether dir or file and use one of the two methods
# dependent on which one.

# returns a group name for each file, to the global array $arry.
def category_names_file(arg, index=2)
  binding.pry
  file_array(arg).each do |absolute_file_path|
    split_file_path = absolute_file_path.split("/")
    group_name = split_file_path[index].split(".")
    $arry << group_name[0]
  end
    return $arry
end

#-------------------------------------------------------------------------------

# just dir
def dir_array(arg)
  Dir.glob("#{arg}/**/*").select{ |f| File.directory? f }
end

# returns a group name for each file, to the global array $arry.
def category_names_dir(arg, arg2=2)
  dir_array(arg).each do |absolute_file_path|
    split_file_path = absolute_file_path.split("/")
    group_name = split_file_path[arg2].split(".")
    $dir_array << group_name[0]
  end
    return $dir_array
end


#------------------------------------------------------------------------------
# This section is used to create the categories of each model
#------------------------------------------------------------------------------
# ModalityGroup
#     auditory, kinesthic, visual
# PersonalityGroup
#     feeling, thinking
# PredicateGroup
#     auditory, gustatory, kinesthic, olfactory, visual
# WordGroup

#------------------------------------------------------------------------------
# small method used to  output information
def output_update(c, model)
  if c != model.count
    puts green("succesfull: currently contains #{model.count} group")
  else
    puts red("The category already exists")
  end
end

#------------------------------------------------------------------------------
# Modality group
#------------------------------------------------------------------------------
# Creates ModalityGroup top level model
# category_names_file("data/modality-group").each do |term|
#   count = ModalityGroup.count
#   puts blue("creating #{term} in modality group: currently contains #{count} group")
#   ModalityGroup.find_or_create_by(category: term)
#   output_update(count, ModalityGroup)
# end
#   $arry.pop($arry.count)
#------------------------------------------------------------------------------
# Personality group
#------------------------------------------------------------------------------
# create PersonalityGroup top level model
category_names_file("data/personality-group").each do |term|
  count = PersonalityGroup.count
  puts blue("creating #{term} in Personality group: currently contains #{count} group")
  PersonalityGroup.find_or_create_by(category: term)
  output_update(count, PersonalityGroup)
end
  $arry.pop($arry.count)
#------------------------------------------------------------------------------
# Predicate group
#------------------------------------------------------------------------------
# create PredicateGroup top level model
category_names_file("data/predicate-group").each do |term|
  count = PredicateGroup.count
  puts blue("creating  #{term} in Predicate group: currently contains #{count} group")
  PredicateGroup.find_or_create_by(category: term)
  output_update(count, PredicateGroup)
end
  $arry.pop($arry.count)

#-------------------------------------------------------------------------------
#   WordGroup - has a two dir structure
#-------------------------------------------------------------------------------
#   - noun        = WordGroup
#         WordGroupRankOne = [abstract, collective, common, countable, literal, plural, proper, uncountable] - 8
#   - verb        = WordGroup
#         WordGroupRankOne = [action, helping, intransitive, irregular, linking, regular, transitive] - 7
#   - adjective   = WordGroup # TODO: only creating 6
#         WordGroupRankOne:
#            -  categories
#                  WordGroupRankTwo = [age, color, compound, condition, feelings,forming,material,qualaies_and_appearence, quantiy, shape, size, taste_and_touch, time,weather_and_temperature]
#            -  descriptive
#                  WordGroupRankTwo = [comparative, posative, superlative]
#            -  limiting
#                  WordGroupRankTwo = [cardinal, definite_and_indefinate, demonstrative, distributive, interrogative, ordinal, possessive, proper]
#   - pronoun     = WordGroup
#         WordGroupRankOne = [demonstrative, indefinite, interrogative, object, personal, possessive, pronouns, reflective, relative] - 9
#   - conjunction = WordGroup
#         WordGroupRankOne = [adverb, conjunction, coordinating, exercise, subordinating] - 5
#
# #-------------------------------------------------------------------------------
# level 1
#-------------------------------------------------------------------------------
# This creates the top level of the WordGroup model structure using an array of dir names
$word.each do |w|
  binding.pry
  WordGroup.find_or_create_by(category: w)
end
#-------------------------------------------------------------------------------
# level 2
#-------------------------------------------------------------------------------

# can have dir with sub dirs other the adjective added to it with out braking the logic,

# Iterates over the $word array, passing the dir title to the category_names_file method
# This generates the WordGroupRankOne category dir name used to ceate the WordGroupRankOne titles.
# the absolute file path generated from category_names_file is split on the 3 as aposed to
# the second index used by the other groups.
$word.each do |name|
  binding.pry
  if name != "adjective"
    category_names_file("data/word-group/#{name}", 3).each do |term|
      my_group = WordGroup.find_by(category: name)
      unless my_group.word_group_rank_ones.find_by(category: term).present?
        my_group.word_group_rank_ones.find_or_create_by(category: term)
      end
    end
  end
  $arry.pop($arry.count)
end

#-------------------------------------------------------------------------------
# adjective word_group_rank_one categories
#-------------------------------------------------------------------------------
# joins WordGroup to WordGroupRankOne and creates categories for rank one.
$word.each do |name|
  if name == "adjective"
    category_names_dir("data/word-group/#{name}", 3).each do |term|
      WordGroup.find_by(category: name).word_group_rank_ones.find_or_create_by(category: term)
    end
  end
  $arry.pop($arry.count)
end

#-------------------------------------------------------------------------------
# adjective word_group_rank_two categories
#-------------------------------------------------------------------------------
# category names dir is used to retrive the dir of data/wordgroup/adjective
# its return array is then iterated over and used to provide category_names_file
# the next lower dir, which is then iterated over joining rank on to rank to.
# the cat_file_names is cleared after each category so as not to add the last
# category contents to it. leaned this the hard way.
$word.each do |name|
  if name == "adjective"
    category_names_dir("data/word-group/#{name}", 3).each do |dir|
      cat_file_names = category_names_file("data/word-group/#{name}/#{dir}", 4)
      cat_file_names.each do |term|
        WordGroupRankOne.find_by(category: dir).word_group_rank_twos.find_or_create_by(category: term)
      end
      cat_file_names.pop(cat_file_names.count)
    end
  end
end

#-------------------------------------------------------------------------------
# Adding words to categories
#-------------------------------------------------------------------------------
# now that the models have been created and categorised each file will be used to
# create word datasets under each category.

#-------------------------------------------------------------------------------
# data structre for file path, class name, and words from each file
#-------------------------------------------------------------------------------
# Gets the absolut path passing in data as the top level dir. these paths are used to
# create a data structure by seperating the path into the model names, categories and full paths
# leaving the words list, which is added by the get_words_from_file method using the absolute file path.
def create_array_of_file_info(arg)
  file_array(arg).each do |item|
    group = item.split("/")
    no_extension = group[2].split(".")

    # create a hash to push to the array.
    data_struct = DataStruct.new
      data_struct.attributes({
        model_group: group[1],
        category: no_extension[0],
        full_path: item,
        words_list: ""
    })
    $info << data_struct
  end
end

# Iterates over the $info array providing the full path name to the File.foreach method.
# This reads each file provided and returns and array for each file of words.
# The string is then cleaned and pushed to the $all_file array as a datastruct containing:
# model_group, category, full_path and words_list, word_list being a string of comma seperated words.
def get_words_from_file
  $info.each do |item|
    File.foreach(item.full_path) do |line|
      $per_file << line
    end
    word_string = $per_file.to_s
    item.words_list = word_string.gsub(/(\[|\"|\\n|\\|\])/, "")
    $all_file << item
    $per_file.pop($per_file.count)
  end
end

#-------------------------------------------------------------------------------
# build word data
#-------------------------------------------------------------------------------
# Iterates over the $all_file array. A if statment determins whether the data belongs
# to the apropriate model_group it then creates a variable my_group based on the category,
# splits the item.word_list creating an array of single words and iterate over them,
# adding them to the my_group.'class'_datasets.


# splits the absolute path from the datastruct full_path, returning a file name without the ext.
def splitter(arg, index)
  pathsplit = arg.full_path.split("/")
  seperated_file_name = pathsplit[index].split(".")
end

def build_db_word_group
  $all_file.each do |item|
    # word group
    if item.model_group == "word-group"
      begin
        unless item.category == "adjective"
          file_name = splitter(item, 3)
          my_group = WordGroupRankOne.find_by(category: file_name[0])
          individual_words = item.words_list.split
            individual_words.each do |item|
              clean_word = strip_junk(item)
              unless my_group.word_datasets.include?(clean_word)
                my_group.word_datasets.find_or_create_by(word: clean_word)
              end
            end
        end
      rescue NoMethodError
        puts red("build_db_word_group: undefined method `word_datasets' for nil:NilClass")
      end
    end
  end
end

def build_db_rank_two
  $all_file.each do |item|
    binding.pry
    # word group
    if item.model_group == "word-group"
      begin
        if item.category == "adjective"
          file_name = splitter(item, 4)
          binding.pry
          my_group = WordGroupRankTwo.find_by(category: file_name[0])
          binding.pry
          individual_words = item.words_list.split
            individual_words.each do |item|
              clean_word = strip_junk(item)
              unless my_group.word_datasets.include?(clean_word)
                my_group.word_datasets.find_or_create_by(word: clean_word)
              end
            end
        end
      rescue NoMethodError
        puts red("build_db_rank_two: Error")
      end
    end
  end
end

def build_db_modality_group
  $all_file.each do |item|
    # modality group
    if item.model_group == "modality-group"
      begin
        my_group = ModalityGroup.find_by(category: item.category)
        individual_words = item.words_list.split
        individual_words.each do |item|
          clean_word = strip_junk(item)
          unless my_group.modality_datasets.include?(clean_word)
            my_group.modality_datasets.find_or_create_by(word: clean_word)
          end
        end
      rescue NoMethodError
        puts red("build_db_modality_group: undefined method `word_datasets' for nil:NilClass")
      end
    end
  end
end

def build_db_predicate_group
  $all_file.each do |item|
    # predicate group
    if item.model_group == "predicate-group"
      begin
        my_group = PredicateGroup.find_by(category: item.category)
        individual_words = item.words_list.split
        individual_words.each do |item|
        clean_word = strip_junk(item)
          unless my_group.predicate_datasets.include?(clean_word)
            my_group.predicate_datasets.find_or_create_by(word: clean_word)
          end
        end
      rescue NoMethodError
        puts red("build_db_predicate_group: undefined method `word_datasets' for nil:NilClass")
      end
    end
  end
end

def build_db_personality_group
  $all_file.each do |item|
    # personality group
    if item.model_group == "personality-group"
      begin
        my_group = PersonalityGroup.find_by(category: item.category)
        individual_words = item.words_list.split
        individual_words.each do |item|
        clean_word = strip_junk(item)
          unless my_group.personality_datasets.include?(clean_word)
            my_group.personality_datasets.find_or_create_by(word: clean_word)
          end
        end
      rescue NoMethodError
        puts red("build_db_personality_group: undefined method `word_datasets' for nil:NilClass")
      end
    end
  end
end

def run
  create_array_of_file_info("data")
  get_words_from_file
  build_db_word_group
  build_db_rank_two
  build_db_predicate_group
  build_db_personality_group
end

run
