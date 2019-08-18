#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'
require 'json'

#-------------------------------------------------------------------------------
# setup 
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

    attr_accessor :words_list

  def initialize(address)
    @address = address
    @results = Array.new
    @words_list = Array.new
    @multi = Array.new
    @category_title = Category.find_by(name: :subtitles)
  end

  # Creates and array of absolute filepaths.
  def subtitles_root_directory(directory_location)
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
      words_list << sanatised
    end
  end

end

