#!/usr/bin/env ruby

require File.expand_path('../../config/environment', __FILE__)
require 'pry'

# -----------------------------------------------------------------------------
# Build Subtitles:
# -----------------------------------------------------------------------------
# 
# Download subtitles and json information, then add each word to the db.
# Each word occurence, syllable and length is then counted as well as a
# duration being added so the frequencey of the word over the course of the 
# video can later be counted.
#
#
system("rake yt:build_subtitles")

# -----------------------------------------------------------------------------
# Build Cross-references:
# -----------------------------------------------------------------------------
#
system("rake yt:build_theme") 

system("rake yt:build_predicate") 

system("rake yt:build_wordgroup")

system("rake yt:build_submodalities")
