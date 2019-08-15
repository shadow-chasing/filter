#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'

#-------------------------------------------------------------------------------
# Color
#-------------------------------------------------------------------------------
def green(mytext) ; "\e[32m#{mytext}\e[0m" ; end
def blue(mytext) ; "\e[36m#{mytext}\e[0m" ; end
def red(mytext) ; "\e[31m#{mytext}\e[0m" ; end

#-------------------------------------------------------------------------------
# Get Data
#-------------------------------------------------------------------------------

class TranscriptData
    attr_accessor :title, :script
  def initialize(args={})
    @title = args[:title]
    @script = args[:script]
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

  # creates and array of absolute filepaths.
  def dir_list
    Dir.glob('/Users/shadow_chaser/Downloads/Youtube/**/*').select{ |f| File.file? f }
  end

  # uses youtube-dl's auto sub generate downloader. downloads to ~/Downloads/Youtube
  def youtube_playlist
    system("youtube-dl --write-auto-sub --sub-lang en --skip-download \'#{@address}\'")
  end

  # two arguments are passed, 
  # a string which it splits on a space as a delimiter, and a title.
  # NOTE needs to skip of title exists from the start rather than try all the
  # words.
  def create_subtitle_words(*args)
      args[0].split.each {|word| Subtitle.create(word: word, title: args[1], category_id: @category_title.id) }
  end

  # build_db
  # iterates over a hash k,v pair. creating a word and its count of repatitions.
  def count_subtitles(arg)
    sub_collection = Subtitle.where(title: arg.title)
    sub_count = sub_collection.group(:word).count

    # add the count to the record 
    sub_count.each {|k,v| sub_collection.find_by(word: k).update(counter: v) }
  end

  def remove_subtitle_words(arg)
      binding.pry
    sub_collection = Subtitle.where(title: arg.title)
    binding.pry
    sub_collection.where.not(id: Subtitle.group(:word).select("min(id)")).destroy_all
  end

  # TODO needs to get playlists of durations
  def duration(url)
      system("youtube-dl --get-duration --skip-download \'#{url}\' | grep -e ETA -e \"[0-9]*\" >duration.txt")
      File.open('duration.txt').read.chomp
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
# build categorys
#------------------------------------------------------------------------------
# create category first, this is because subtitles expects the foreign key to
# be added to which category it belongs, the rest are used by the
# cross-refernce.
cat = ["subtitles", "filter", "word group", "predicate"]

cat.each do |c|
    Category.find_or_create_by(name: c)
end
#------------------------------------------------------------------------------
# Take a user input
#------------------------------------------------------------------------------

puts "Enter URL:\n"

user_input = gets


#------------------------------------------------------------------------------
# create the initial subtitle downloads
#------------------------------------------------------------------------------
transcript = GenerateTranscript.new(user_input.chomp)

if transcript.youtube_playlist.present? 
    transcript.youtube_playlist
else
    exit
end

$arry = []

#------------------------------------------------------------------------------
# iterates over the dir_list method, which when called creates an arrray of absolute
# file paths. spliting the variable on the / creating a array.
#------------------------------------------------------------------------------
transcript.dir_list.each do |video|

  # create and array from the file path. seperating on the seperator /.
  title = video.split("/")

  puts green("creating #{title[7]}")

  #----------------------------------------------------------------------------
  # remove tags
  #----------------------------------------------------------------------------
  # read in the subtitle and strip out the bad tags.
  transcript.read_file(video)

  #----------------------------------------------------------------------------
  # create a words list
  #----------------------------------------------------------------------------
  # join all lines then split the lines on the \n charactor, rejoining to create a
  # string containing indevidual words seperated by space. This is important
  # because they will later be seperated on that space.
  dialouge = $arry.uniq.join.split("\n").join(" ")

  #----------------------------------------------------------------------------
  # Create the data
  #----------------------------------------------------------------------------
  # create a struct containing the title and the string of words list.
  data = TranscriptData.new(title: title[7], script: dialouge)

  #----------------------------------------------------------------------------
  # count titles
  #----------------------------------------------------------------------------
  # group returns the first of each title
  initial_table = Subtitle.group(:title)

  #----------------------------------------------------------------------------
  # creates the subtitles
  #----------------------------------------------------------------------------
  # passes the string of space sperated words and the title in.
  transcript.create_subtitle_words(data.script, data.title)
  transcript.count_subtitles(data)
  transcript.word_length
  transcript.sylables
  transcript.remove_subtitle_words(data)

  #----------------------------------------------------------------------------
  # checks whether the Subtitle.title.count has increased
  #----------------------------------------------------------------------------
  # group returns the first of each title
  title_list = Subtitle.group(:title)

  if title_list.count > initial_table.count
    puts green("database now contains #{title_list.count} title(s)")
  else
    puts red("database has not increased")
  end
end
