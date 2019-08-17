#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'
require 'json'

#-------------------------------------------------------------------------------
# Get Data
#-------------------------------------------------------------------------------

class TranscriptData
    attr_accessor :title, :script, :duration
  def initialize(args={})
    @title = args[:title]
    @script = args[:script]
    @duration = args[:duration]
  end
end

class GenerateTranscript

  def initialize(address)
    @address = address
    @results = Array.new
    @arry = Array.new
    @multi = Array.new
    @category_title = Category.find_by(name: :subtitles)
  end

  # Creates and array of absolute filepaths.
  def dir_list(directory_location)
    Dir.glob(directory_location + "/**/*").select{ |f| File.file? f }
  end

  # Uses youtube-dl's auto sub generate downloader. downloads to ~/Downloads/Youtube
  def youtube_playlist
    system("youtube-dl --write-auto-sub --sub-lang en --skip-download --write-info-json \'#{@address}\'")
  end

  # Two arguments are passed, a string which it splits using space as a delimiter
  # creating and array of words then iterating over the array, and a title.
  # lastly it adds the subtitles category id so the foreign key constraint is satisfied
  def create_subtitle_words(*args)
    args[0].split.each {|word| Subtitle.create(word: word, title: args[1], duration: args[2], category_id: @category_title.id) }
  end

  # Counts all occurences of each word, creating a hash of the results.
  # Then iterates over the hash using the find_by method retrieving the first
  # occurence of the word based on the title and word. 
  # This is important later because all subtitles have the count added to only 
  # the first occurence of the word, the rest are deleted.
  # lastly the counter is updated adding the value of the hash count.
  def count_subtitles(arg)
    my_sub = Subtitle.where(title: arg.title).group(:word).count
    my_sub.each {|k,v| Subtitle.find_by(title: arg.title, word: k).update(counter: v) }
  end

  # finds all the subtitles with title then does a where.not and passes in an
  # array of ids, excluding them from the destroy_all clause.
  def remove_subtitle_words(arg)
    my_sub = Subtitle.where(title: arg.title)
    my_sub.where.not(id: my_sub.group(:word).select("min(id)")).destroy_all
  end

  # plucks the id and word of each subtitle item
  def word_length
    Subtitle.pluck([:id, :word]).each {|item| Subtitle.find(item[0]).update(length: item[1].length) }
  end

  def syllable_count(word)
    word.downcase!
    return 1 if word.length <= 3
    word.sub!(/(?:[^laeiouy]es|ed|[^laeiouy]e)$/, '')
    word.sub!(/^y/, '')
    word.scan(/[aeiouy]{1,2}/).size
  end

  def sylables
    Subtitle.all.each { |item| item.update(syllable: syllable_count(item.word)) }
  end

  def read_file(arg)
    File.readlines(arg).each do |line|
      remove_color_tag = line.gsub(/<[^>]*>/, "")
      sanatised = remove_color_tag.gsub(/([^\w\s]|([0-9]|\:|\.))/, "").downcase
      $arry << sanatised
    end
  end
end


#------------------------------------------------------------------------------
# Global arrays
#------------------------------------------------------------------------------
$arry = []

#------------------------------------------------------------------------------
# build categorys
#------------------------------------------------------------------------------
# create category first, this is because subtitles expects the foreign key to
# be added to which category it belongs, the rest are used by the cross-refernce.
#------------------------------------------------------------------------------
category_titles = ["subtitles", "filters", "wordgroups", "predicates"]

category_titles.each do |category_name|
    Category.find_or_create_by(name: category_name)
end

#------------------------------------------------------------------------------
# Take a user input
#------------------------------------------------------------------------------
puts "Enter URL:\n"

user_input = gets

#------------------------------------------------------------------------------
# validate address is beginning with the youtube address.
#------------------------------------------------------------------------------
if user_input.chomp =~ /^(https|http)\:(\/\/)[w]{3}\.(youtube)\.(com)/

    # instansiate GenerateTranscript.
    # pass in the url which sets the @address instance variable, used by the
    # youtube_playlist method.
    transcript = GenerateTranscript.new(user_input.chomp)

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
filepaths_array = transcript.dir_list("/Users/shadow_chaser/Downloads/Youtube")

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

    # get just the title to use as the key from the file path.
    title = item.split("/")[7]

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

    # json file
    json_info = value[0]

    # subtitles
    subtitle_auto_captions = value[1]

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
    dialouge = $arry.uniq.join.split("\n").join(" ")

    #--------------------------------------------------------------------------
    # Create the data
    #--------------------------------------------------------------------------
    # create a struct containing the title and the string of words list.
    data = TranscriptData.new(title: title, script: dialouge, duration: duration)

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
