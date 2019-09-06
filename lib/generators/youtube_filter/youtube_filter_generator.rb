require 'generators/youtube_filter/youtube_generator_helper'

class YoutubeFilterGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

    # include the helper 
    include Rails::Generators::ResourceHelpers
    include Generators::YoutubeGeneratorHelper

    binding.pry
    class_option :user, :type => :string, :default => false

    binding.pry
    # build 
    build_group()

    # rank ones
    build_group_rank_one()

    # rank twos
    build_group_rank_two()

    # rank three
    build_group_rank_three()

    # result
    build_group_result()


end
