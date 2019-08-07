#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'


class BlacklistData

  def initialize
    @arry = Array.new
  end

  # open file of words
  def words_list
    file = "blacklist/blacklist.txt"
    File.foreach(file) do |line|
       @arry << line.chomp
    end
  end

  # load it in to the db
  def create_blacklist
    @arry.each do |word|
      Blacklist.find_or_create_by(bad_word: word)
    end
  end

  # remove blacklisted words
  def remove_blacklisted_from_sub
    Blacklist.all.each do |b_word|
      binding.pry
      if Sub.find_by(word: b_word.bad_word).present? then Sub.where(word: b_word.bad_word).map { |gone| gone.destroy  } end
    end
  end

end

blacklist = BlacklistData.new
blacklist.words_list
blacklist.create_blacklist
blacklist.remove_blacklisted_from_sub
