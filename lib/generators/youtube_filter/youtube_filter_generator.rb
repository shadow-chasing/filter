class YoutubeFilterGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  include Rails::Generators::YoutubeGeneratorHelper

    # create the group
    create_group()

    # create the group result
    create_group_results()

    # create group rank one
    create_group_rank_one()

    # create group rank two
    cretae_group_rank_two()

end

