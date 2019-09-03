#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'
require 'json'
require 'classes-youtube-filter'

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

# Home directory established by the ENV Variable. Make sure that the script
# runner is a signed in user or the ENV['HOME'] may not be set.
home = ENV['HOME']

# Join the home dir to the Downloads/Youtube directory.
root = File.join(home, "Downloads/Youtube-Filter/Youtube")

# base directory
base_downloads = YoutubeFilter.base_directory(root)

# return an array or each file from the descendent 
filepaths_array = transcript.subtitles_root_directory(base_downloads)

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

    # duration of the video - integer
    duration = data["duration"]

    # uploader information - string
    uploader = data["uploader"]

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
    # unless the title is present in the database.
    unless Subtitle.find_by(title: data.title).present?

        binding.pry
        # passes the string of space separated words and the title in.
        transcript.create_subtitle_words(data.script, data.title, data.duration)

        binding.pry
        # if subtitle is now created run the other methods
        if Subtitle.find_by(title: data.title).present?
            transcript.count_subtitles(data)

            # count the length of each word
            transcript.word_length

            # count how many syllables each word has 
            transcript.sylables

            # remove all duplicate words other the the first occurence. 
            transcript.remove_subtitle_words(data)

            # count the frequecy the word occurs
            transcript.frequency(Subtitle.all)

        end
        
        #----------------------------------------------------------------------
        # move subtitles to complete when finished
        #----------------------------------------------------------------------

        fs = File::SEPARATOR

        # Base name of the directory 
        downloads = "Downloads/Youtube-Filter/"

        # join path to $HOME/Downloads/Youtube-Filter/Youtube/$UPLOADER
        youtube_uploader = File.join(home, downloads + "Youtube/" + uploader)

        # join path to $HOME/Downloads/Youtube-Filter/Complete/$UPLOADER
        complete_path = File.join(home, downloads + "Complete/" + uploader)

        # join the complete path to the title of the video
        title_path = complete_path + fs + title

        # make root dir of uploader
        Dir.mkdir(complete_path) unless File.exists?(complete_path)
        
        # make dir of title
        Dir.mkdir(title_path) unless File.exists?(title_path)

        # create an array of decending files from the video title.
        files_array = Dir.glob(youtube_uploader + fs + key + "/**/*")

        # select none dirs
        result = files_array.select {|f| unless File.directory?(f) then f end }

        # iterate over the array moving each file in the array to the new location
        result.each {|file| 

            # get just the extension name to test against in the condition.
            extension_name = File.basename(file)

            if File.extname(extension_name) == ".vtt"

                # join paths to the exact file and move to the completed directory
                File.rename(file, complete_path + fs + title + fs + File.basename(file)) 

            elsif File.extname(extension_name) == ".json"

                # join paths to the exact file and move to the completed directory
                File.rename(file, complete_path + fs + title + fs + File.basename(file)) 

            end

        }

    end

end


