#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'

#------------------------------------------------------------------------------
# Directory's
#------------------------------------------------------------------------------
#
# Define directory's downloads and complete.
#
#

# Define home directory.
home = ENV['HOME']

# Join the home dir to the Downloads/Youtube directory.
root = File.join(home, "Downloads/Youtube-Filter")

# Attach the root dir to the youutbe directory.
youtube = File.join(root, "Youtube")

# Attach the root dir to the complete directory.
complete = File.join(root, "Complete")

#--------------------------------------------------------------------------
# Config
#--------------------------------------------------------------------------
#
# Evaluate if ~/.config ~/.config/youtube-dl and ~/.config/youtube-dl/config
# exist and make them if they do not.
#
#

# Config join to the root directory.
config = File.join(home, ".config")

# Join the config dir to the youtube-dl directory.
youtube_dl = File.join(config, "youtube-dl/")

# Config file.
conf = File.join(youtube_dl, "config")

# Make the directory.
Dir.mkdir(config) unless File.exists?(config)

# Make the directory.
Dir.mkdir(youtube_dl) unless File.exists?(youtube_dl)

# TODO erroring???
# Remove old config file.
if File.exists?(conf)
   delete(conf)
end


#--------------------------------------------------------------------------
# Move Template 
#--------------------------------------------------------------------------
#
# Move config template file from script root dir to
# ~/.config/youutbe-dl/config
#
#

# Script root dir.
root_path = File.dirname(__FILE__)

# template dir relative to the root_path.
template = File.join(root_path, "template/config")

# Move template config file to ~/.config/youtube-dl/config
if File.exists?(template)
    File.rename(template, youtube_dl + "config")
end



#--------------------------------------------------------------------------
# make directory's
#--------------------------------------------------------------------------
#
# ~/Downloads/Youtube-Filter/
#
#
Dir.mkdir(root) unless File.exists?(root)

#
# ~/Downloads/Youtube-Filter/youtube/
#
#
Dir.mkdir(youtube) unless File.exists?(youtube)

#
# ~/Downloads/Youtube-Filter/complete/
#
#
Dir.mkdir(complete) unless File.exists?(complete)

