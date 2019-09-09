#!/usr/bin/env ruby

require File.expand_path('../../config/environment', __FILE__)
require 'pry'

# -----------------------------------------------------------------------------
# Build Directories
# -----------------------------------------------------------------------------
#
# Build directories creates a youtube config file in
# ~/.config/youtube-dl/config with a download template expected for the
# youtube-filter it then creates the directory structure in downloads for
# downloaded and complated directories.
# 

# set the value to true for the while loop.
run = true

# run loop until the run variable is change to false.
while run == true

    # user options
    puts "Run Directory Setup?\n1.yes\n2.no\n"

    # take user input
    user = gets
    answer = user.chomp

    if answer == "yes"
        system("ruby directorys.rb")
        run = false
    elsif answer == "no"
        puts "in no"
        run = false
    else
        puts "Please Enter yes or no."
    end

end

# -----------------------------------------------------------------------------
# Seed Categories:
# -----------------------------------------------------------------------------
#
# Subtitles
# Filters
# Wordgroups
# Predicates
#
#
system("rake db:seed")


# -----------------------------------------------------------------------------
# Data:
# -----------------------------------------------------------------------------
#
# Builds the category infrastructure each word is then referenced against.
#
#
system("rake yt:build_categories")       
