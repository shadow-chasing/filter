#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'
require 'nokogiri'
require 'open-uri'

class SubtitleCreate

  def initialize(arg)
    @transcript_file = arg
  end

  # takes an argument, file name and converts it to a string.
  def transcript(file)
      words = File.read(file)
      return words.to_s
  end

  # takes one argument, a string which it splits on a space as a delimiter.
  # creates a hash with default values of 0 then uses the word as the key
  # and incrments a count for each reptition.
  def hashed_count_order(string)
      words = string.split(' ')
      frequency = Hash.new(0)
      words.each { |word| frequency[word.downcase] += 1 }
      Hash[frequency.sort_by {|k,v| v.to_i }]
  end

  # iterates over a hash k,v pair. creating a word and its count of repatitions.
  def build_bd
    hashed_count_order(transcript(@transcript_file)).each {|key, value|
      my_sub = Sub.find_or_create_by(word: key,counter: value)
      my_sub.update(title: "HOMEMADE PASTA FROM SCRATCH")
    }
  end

end

subtitle = SubtitleCreate.new("transcript.txt")
subtitle.build_bd
