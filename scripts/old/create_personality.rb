#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'

# create and array
$arry = Array.new

# open file of words
def words_list(file)
    File.foreach(file) do |line|
       $arry << line.chomp
    end
end

# load it in to the db
def thinking_db
  $arry.each do |w|
      Thinking.find_or_create_by(word: w)
  end
  $arry.pop($arry.count)
end

def feeling_db
  $arry.each do |w|
      Feeling.find_or_create_by(word: w)
  end
  $arry.pop($arry.count)
end

words_list("personality/thinking.txt")
thinking_db

words_list("personality/feeling.txt")
feeling_db
