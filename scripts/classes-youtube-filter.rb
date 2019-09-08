#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'
require 'json'

#-------------------------------------------------------------------------------
#   Module  
#-------------------------------------------------------------------------------
#
#           YoutubeFilter               
#               This modle contains three classes and two independent methods.
#
#
#-------------------------------------------------------------------------------
#   Classes   
#-------------------------------------------------------------------------------
#           CategoryStructure
#               CategoryStructure is used by build-categorys
#
#           TranscriptData
#               TranscriptData is used by setup
#
#           GenerateTranscript
#               GenerateTranscipt is used by setup
#
#           TimeFormatter
#-------------------------------------------------------------------------------
#   Methods
#-------------------------------------------------------------------------------
#           base_directory
#           cat_id
#
#-------------------------------------------------------------------------------

module YoutubeFilter

    # 
    # CategoryStructure is used by build-categorys
    #
    class CategoryStructure

        attr_accessor :first, :second, :third, :fourth, :full_path, :words_list

        def build_categorys(arg={})
            @first = arg[:first]
            @second = arg[:second]
            @third = arg[:third] || nil
            @fourth = arg[:fourth] || nil
            @full_path = arg[:full_path]
            @words_list = arg[:words_list]
        end

        # creates and array of absolute filepaths.
        def full_path_array(arg)
            Dir.glob("#{arg}/**/*").select{ |f| File.file? f }
        end

    end

    # 
    # TranscriptData is used by setup
    #
    class TranscriptData

        attr_accessor :title, :script, :duration

        def initialize(args={})
            @title = args[:title]
            @script = args[:script]
            @duration = args[:duration]
        end
    end

    # 
    # GenerateTranscipt is used by setup
    #
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
            system("youtube-dl --write-auto-sub --sub-format best --sub-lang en --skip-download --write-info-json \'#{@address}\'")
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
            Subtitle.all.each {|sub| sub.update(length: sub.word.length) }
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

        # divide the amout of occurences by the duration 
        def frequency(subs)
            subs.all.each do |sub| 
                begin
                    sub.update(frequency: Time.at(sub.duration / sub.counter).utc.strftime("%H"":""%M"":""%S")) 
                rescue TypeError => e
                    puts "Rescued: #{e.inspect}"
                end
            end
        end
        
        # times the word length by the sylable length, then times the result by 
        # the number of occurences.
        def word_rank
            Subtitle.all.each do |sub| 
                begin
                    rank = sub.counter * (sub.length * sub.syllable) 
                    sub.update(word_rank: rank)
                rescue "Exception => e"
                    puts "Rescued: #{e.inspect}"
                end
            end
        end

    end

    class TimeFormatter

        def format_time (timeElapsed)

            @timeElapsed = timeElapsed

            #find the seconds
            seconds = @timeElapsed % 60

            #find the minutes
            minutes = (@timeElapsed / 60) % 60

            #find the hours
            hours = (@timeElapsed/3600)

            #format the time

            return hours.to_s + ":" + format("%02d",minutes.to_s) + ":" + format("%02d",seconds.to_s)
        end
    end


    def self.base_directory(base_download)
        @base_download_dir = base_download 
    end


    # category wordgroups id
    def self.cat_id(cat_name)
        Category.find_by(name: cat_name).id
    end

end
