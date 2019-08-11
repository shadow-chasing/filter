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

  def initialize
    @results = Array.new
    @arry = Array.new
    @multi = Array.new
    @dur = duration("https://www.youtube.com/watch?v=2dLN3cvOEZg")
  end

  # creates and array of absolute filepaths.
  def dir_list
    Dir.glob('/Users/shadow_chaser/Downloads/Youtube/**/*').select{ |f| File.file? f }
  end

  # uses youtube-dl's auto sub generate downloader. downloads to ~/Downloads/Youtube
  def youtube_playlist(arg)
    puts blue("downloading #{arg} from youtube.com")
    binding.pry
    system("youtube-dl --write-auto-sub --sub-lang en --skip-download \'#{arg}\'")
  end

  # TODO needs to get playlists of durations
  def duration(url)
      binding.pry
      system("youtube-dl --get-duration --skip-download \'#{url}\' | grep -e ETA -e \"[0-9]*\" >duration.txt")
      File.open('duration.txt').read.chomp
      text.gsub(/\:/, ".")
  end



  def read_file(arg)
    File.readlines(arg).each do |line|
      remove_color_tag = line.gsub(/<[^>]*>/, "")
      sanatised = remove_color_tag.gsub(/([^\w\s]|([0-9]|\:|\.))/, "").downcase
      $arry << sanatised
    end
  end

  def paragraph(arg)
    file = File.read(arg)
    file.chomp
  end

  # takes one argument, a string which it splits on a space as a delimiter.
  # creates a hash with default values of 0 then uses the word as the key
  # and incrments a count for each reptition.
  def hashed_count_order(string)
      words = string.split(' ')
      frequency = Hash.new(0)
      words.each { |word| frequency[word.downcase] += 1 }
      Hash[frequency.sort_by {|k,v| v.to_i }]
  end

  # iterates over a hash k,v pair. creating a word and its count of repatitions.
  def build_bd(*args)
    hashed_count_order(args[0]).each {|key, value|
      unless key.blank?
        mycat = Category.find_by(name: :subtitles)
        my_sub = Subtitle.find_or_create_by(word: key, counter: value, category_id: mycat.id)
        my_sub.update(title: args[1], duration: @dur)
      end
    }
  end

  # plucks the id and word of each subtitle item
  def word_length
    Subtitle.pluck([:id, :word]).each {|item| Subtitle.find(item[0]).update(length: item[1].length) }
  end

  def new_count(word)
    word.downcase!
    return 1 if word.length <= 3
    word.sub!(/(?:[^laeiouy]es|ed|[^laeiouy]e)$/, '')
    word.sub!(/^y/, '')
    word.scan(/[aeiouy]{1,2}/).size
  end

  def sylables
    Subtitle.all.each { |item| item.update(syllable: new_count(item.word)) }
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

transcript = GenerateTranscript.new

#NOTE add the duration url too.
transcript.youtube_playlist("https://www.youtube.com/watch?v=2dLN3cvOEZg")
# iterates over the dir_list method, which when called creates an arrray of absolute
# file paths. spliting the variable on the / creating a array. title[5] being the filename
# and video being the absolut path. the absolute path is then passed into the File.readlines
# removing timestamps and braces and creating an array. The array is then pushed to an array,
# @multi as @multi[0]. These are the two variales used by the class TranscriptData as a hash.
# which is pushed to an array @results and retriveable as variable.title and variable.script when
# iterated over.
# iterates over the @result array. joining the index array into a string needed to pass
# the build_bd method.
$arry = []


transcript.dir_list.each do |video|
  title = video.split("/")
  puts green("creating #{title[5]}")
  transcript.read_file(video)
  dialouge = $arry.uniq.join.split("\n").join(" ")
  data = TranscriptData.new(title: title[5], script: dialouge)

  initial_table = Subtitle.all.uniq{|t| t[:title]}
  transcript.build_bd(data.script, data.title)
  title_list = Subtitle.all.uniq{|t| t[:title]}
  transcript.word_length
  transcript.sylables

  if title_list.count > initial_table.count
    puts green("database now contains #{title_list.count} title(s)")
  else
    puts red("database already contains #{title[5]}")
  end
end
