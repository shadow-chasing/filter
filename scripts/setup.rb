#!/usr/bin/env ruby

require File.expand_path('../../config/environment', __FILE__)
require 'pry'

# Build subtitles
system("rake yt:build_subtitles")

# Build categories: builds the category infrastructure each word is then referenced against
system("rake yt:build_categories")       

# Build cross-reference: adds the categories predicate, wordgroup and filter to subtitle.word
system("rake yt:build_predicates")

