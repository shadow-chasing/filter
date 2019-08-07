#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'


class WordNode

  attr_accessor :title, :paragraph, :sentence, :node, :word

  def initialize(options={})
    @tile = options[:title] || ""
    @paragraph = options[:paragraph] || 1
    @sentence = options[:sentence] || 1
    @node = options[:node] || nil
    @word = options[:word] || nil
  end

end

class PageText

  def initialize
    @page = Array.new
  end
  # creates and array of absolute filepaths.
  def dir_list
    Dir.glob('/Users/shadow_chaser/Downloads/Youtube/**/*').select{ |f| File.file? f }
  end

  # TODO - add title to the datastruct and build the bd with the title included.
  def title
    dir_list.map { |item| item.split("/")[5] }
  end

  def paragraph
    @page.join.split("\.").map {|item| if item.present? then item end }.compact!
  end

  def sentence
    @page.map { |item| item.split("\n")  }
  end

  def read_file(arg)
    File.readlines(arg[0]).each do |line|
      sanatised = line.gsub(/^[0-9][0-9]\:.*$/, "").downcase
      remove_new_line = sanatised.gsub(/^\n/, "")
      @page << remove_new_line
    end
    @page.map! { |item| unless item.empty? then item end }.compact!
  end

end

$final = []
page = PageText.new
page.read_file(page.dir_list)
page.paragraph.each_with_index {|paragraph, paragraph_count|
  paragraph.split("\n").each_with_index {|sentence, sentence_count| sentence.split(" ").each_with_index {|word, word_count|
      data = WordNode.new(paragraph:paragraph_count, sentence:sentence_count, node:word_count, word:word)
      $final << data
    }
  }
}

# iterate over the final array of datastructs and create a database entry.
$final.each do |item|
  if item.present?
    my_paragraph = Paragraph.find_or_create_by(paragraph: item.paragraph, title: :tit)
    unless my_paragraph.sentences.find_by(sentence: item.sentence).present?
      my_para_sentence = my_paragraph.sentences.find_or_create_by(sentence: item.sentence)
        unless my_para_sentence.nodes.find_by(node: item.node).present?
          para_sentence_node = my_para_sentence.nodes.find_or_create_by(node: item.node)
          unless para_sentence_node.words.find_by(word: item.word).present?
            para_sentence_node.words.find_or_create_by(word: item.word)
          end
        end

    end
  end
end
