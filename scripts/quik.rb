#!/usr/bin/env ruby

require File.expand_path('../../config/environment', __FILE__)
require 'pry'
require 'classes-youtube-filter'

first_file = "/Users/shadow_chaser/Code/Ruby/Projects/filter/scripts/data/word/adjective/descriptive/comparative/er"
second_file = "/Users/shadow_chaser/Code/Ruby/Projects/filter/scripts/data/word/adjective/descriptive/comparative/ier"

#------------------------------------------------------------------------------
# global arrays
#------------------------------------------------------------------------------
$word_list = []
$one_syllable = []
$two_syllable = []


#------------------------------------------------------------------------------
# methods
#------------------------------------------------------------------------------
def syllable_count(word)
    word.downcase!
    return 1 if word.length <= 3
    word.sub!(/(?:[^laeiouy]es|ed|[^laeiouy]e)$/, '')
    word.sub!(/^y/, '')
    word.scan(/[aeiouy]{1,2}/).size
end

def read_file(arg)
    File.readlines(arg).each do |line|
        $word_list << line
    end
end


#------------------------------------------------------------------------------
# read in the file 
#------------------------------------------------------------------------------
read_file(first_file)


$word_list.each do |item|

    if syllable_count(item) == 2 
        $one_syllable.push(item)
    end
    
end

# clear the array
$word_list.pop($word_list.count)


File.open("one", "w+") do |f|
  $one_syllable.each { |element| f.puts(element) }
end

#------------------------------------------------------------------------------
# 
#------------------------------------------------------------------------------
read_file(second_file)


#------------------------------------------------------------------------------
# open fie 
#------------------------------------------------------------------------------

$word_list.each do |item|

    if syllable_count(item) == 2
        $two_syllable.push(item)
    end

end

File.open("two", "w+") do |f|
  $two_syllable.each { |element| f.puts(element) }
end
