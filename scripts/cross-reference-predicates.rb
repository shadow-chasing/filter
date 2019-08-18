#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'

# Find predicate by named category and return assosiated dataset.
def predicate_category(arg)
  PredicateGroup.find_by(category: arg).predicate_datasets
end

# Get predicate by id and return the category name.
def get_title(arg)
  PredicateGroup.find_by(id: arg).category
end

# Takes one argument a modality and returns a dataset which is then iterated over.
# Subtitle is then searched for the dataset words and if present a record is created
# between Subtitle and PredicateResults.

def build_predicate_result(arg)
  predicate_category(arg).each do |dataset|
      word_array = Subtitle.where(word: dataset.word)
    if word_array.present?
      word_array.each do |subtitle_word|
        subtitle_word.predicate_results.find_or_create_by(group: :predicate, predicate: get_title(dataset.predicate_group_id))

        mycat = Category.find_or_create_by(name: :predicates)
        # add the new category id to the spercific predicate group
        subtitle_word.update(category_id: mycat.id)
      end
    end
  end
end

#------------------------------------------------------------------------------
# Build Subtitle PredicateResult
#------------------------------------------------------------------------------
# Searches subtitle for word contained in PredicateGroup.dataset and creates a
# record if its found.
#------------------------------------------------------------------------------
# Auditory
#------------------------------------------------------------------------------
build_predicate_result("auditory")
#------------------------------------------------------------------------------
# Visual
#------------------------------------------------------------------------------
build_predicate_result("visual")
#------------------------------------------------------------------------------
# Kinesthetic
#------------------------------------------------------------------------------
build_predicate_result("kinesthetic")
#------------------------------------------------------------------------------
# Olfactory
#------------------------------------------------------------------------------
build_predicate_result("olfactory")
#------------------------------------------------------------------------------
# Gustatory
#------------------------------------------------------------------------------
build_predicate_result("gustatory")
