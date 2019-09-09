require 'generators/youtube_filter/youtube_generator_helper'

class YoutubeFilterGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

    # include the helper 
    include Rails::Generators::ResourceHelpers
    include Generators::YoutubeGeneratorHelper


    puts "#{name}"

    binding.pry
    # build 
    build_group(name)

    # rank ones
    build_group_rank_one(name)

    # rank twos
    build_group_rank_two(name)

    # rank three
    build_group_rank_three(name)

    # result
    build_group_result(name)


end
