#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'

# remove blacklisted words
Blacklist.all.each do |b_word|
  if Sub.find_by(word: b_word.bad_word).present? then Sub.find_by(word: b_word.bad_word).destroy end
end
