#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'

#-----------------------------------------------------------------------------
# build-categories
#-----------------------------------------------------------------------------
class CategoryStructure

  attr_accessor :first, :second, :third, :fourth, :full_path, :words_list

    def build_categorys(arg={})
        @first = arg[:first]
        @second = arg[:second]
        @third = arg[:third] || nil
        @fourth = arg[:fourth] || nil
        @full_path = arg[:full_path]
        @words_list = arg[:words_list]
    end

    # creates and array of absolute filepaths.
    def full_path_array(arg)
        Dir.glob("#{arg}/**/*").select{ |f| File.file? f }
    end

end
