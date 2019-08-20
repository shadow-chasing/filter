#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'
require 'json'
require 'classes-youtube-filter'

#------------------------------------------------------------------------------
# SEED DB
#------------------------------------------------------------------------------
Rails.application.load_seed

#------------------------------------------------------------------------------
# Take a user input
#------------------------------------------------------------------------------
puts "Please Enter URL:\n"

user_input = gets

#------------------------------------------------------------------------------
# validate address is beginning with the youtube address.
#------------------------------------------------------------------------------
if user_input.chomp =~ /^(https|http)\:(\/\/)[w]{3}\.(youtube)\.(com)/

    # instansiate GenerateTranscript.
    # pass in the url which sets the @address instance variable, used by the
    # youtube_playlist method.
    transcript = YoutubeFilter::GenerateTranscript.new(user_input.chomp)

    # download the single url or playlist, 
    transcript.youtube_playlist

else 
    puts "Invalid URL: please enter a valid URL" 
    exit
end

#------------------------------------------------------------------------------
# Creates an arrray of absolute file paths. 
# Returns .json and .vtt files 
#------------------------------------------------------------------------------
filepaths_array = transcript.subtitles_root_directory("/Users/shadow_chaser/Downloads/Youtube")

#------------------------------------------------------------------------------
# create a hash with arrays as values.
#------------------------------------------------------------------------------
synced = Hash.new { |h, k| h[k] = [] }

#------------------------------------------------------------------------------
# create a hash key from the title and add to the array value each file, .json
# and .vtt, this is done so i can count the array of each key, if there are two
# items i know both subtitles and json information where correctly downloaded.
#------------------------------------------------------------------------------
filepaths_array.each do |item|

    # item is split and the second to the last array index is used.
    # the last item from the array is the file name the preceding one to
    # that is the name of the directory, the dir is used as the key ( title ) 
    # as it negates having to remove the extentions.
    title = item.split("/")[-2]

    # create a key based on the title.
    synced["#{title}"]

    # find the hash key and append to the array.
    (synced["#{title}"] ||=[]) << item
end

#------------------------------------------------------------------------------
# remove any k,v pairs that do not have 2 items.
#------------------------------------------------------------------------------
synced.delete_if {|key, value| value.count != 2 }

#------------------------------------------------------------------------------
# key = title, value = []
# iterate over the datastruct each key, value pair.
#------------------------------------------------------------------------------
synced.each do |key, value|


    # value is an array or two files .json and .vtt, 
    # use the file extension type to match the file ext then set the variables.
    if File.extname(value[0]) =~ /.json/
        json_info = value[0]
        subtitle_auto_captions = value[1]
    else
        json_info = value[1]
        subtitle_auto_captions = value[0]
    end


    #--------------------------------------------------------------------------
    # json file
    #--------------------------------------------------------------------------
    data = JSON.parse(File.read(json_info))

    # get the json attributes from the info.json file
    title = data["title"]

    duration = data["duration"]

    #--------------------------------------------------------------------------
    # remove tags
    #--------------------------------------------------------------------------
    # read in the subtitle and strip out the bad tags.
    transcript.read_file(subtitle_auto_captions)

    #--------------------------------------------------------------------------
    # create a words list
    #--------------------------------------------------------------------------
    # join all lines then split the lines on the \n character, rejoining to create a
    # string containing individual words separated by space. This is important
    # because they will later be separated on that space.
    dialouge = transcript.words_list.uniq.join.split("\n").join(" ")

    #--------------------------------------------------------------------------
    # Create the data
    #--------------------------------------------------------------------------
    # create a struct containing the title and the string of words list.
    data = YoutubeFilter::TranscriptData.new(title: title, script: dialouge, duration: duration)

    #--------------------------------------------------------------------------
    # creates the subtitles
    #--------------------------------------------------------------------------
    # unless subtitle.title is already created enter the condition.
    unless Subtitle.find_by(title: data.title).present?

        # passes the string of space separated words and the title in.
        transcript.create_subtitle_words(data.script, data.title, data.duration)

        # if subtitle is now created run the other methods
        if Subtitle.find_by(title: data.title).present?
            transcript.count_subtitles(data)
            transcript.word_length
            transcript.sylables
            transcript.remove_subtitle_words(data)
        end
        
    end

end


