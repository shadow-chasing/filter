#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
require 'pry'
require 'json'


binding.pry
data = JSON.parse(File.read("/Users/shadow_chaser/Downloads/Youtube/Jenna/20190722/Pod/podcast.json"))

title = data["title"]
duration = data["duration"]
