 module Generators

    # Some helpers for generating scaffolding
    module YoutubeGeneratorHelper

    # generate model group with one attribute a category. 
    def create_group(*args)
       generate "model #{args[0]} category:string" 
    end

    # generate model group_result. 
    def create_group_results(*args)
       generate "model #{args[0]} rank_one:string rank_two:string rank_three:string group:string predicate:string subtitle:references" 
    end

    # 
    def create_group_rank_one(*args)
       generate "model #{args[0]} category:string" 
    end

    #
    def create_group_rank_two(*args)
       generate "model #{args[0]} category:string word_group_rank_one:references" 
    end

 end
