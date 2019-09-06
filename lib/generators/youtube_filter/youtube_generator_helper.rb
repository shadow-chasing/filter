module Generators
    module YoutubeGeneratorHelper

    attr_accessor :options, :attributes

    def build_group(*args)
        generate "model" + args[0] + "Group category:string"
    end

    def build_group_rank_one(*args)
        generate "model" +  args[0] + "GroupRankOne category:string"
    end

    def build_group_rank_two(*args)
        generate "model" +  args[0] + "GroupRankTwo category:string theme_group_rank_one:references" 
    end

    def build_group_rank_three(*args)
        generate "model" +  args[0] + "GroupRankTwo category:string theme_group_rank_one:references" 
    end

    def build_group_result(*args)
        generate "model" +  args[0] + "GroupRankTwo category:string theme_group_rank_one:references"
    end

    end
end

