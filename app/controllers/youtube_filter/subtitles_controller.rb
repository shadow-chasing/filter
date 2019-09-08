class YoutubeFilter::SubtitlesController < ApplicationController
  before_action :set_subtitle, only: [:edit, :update, :destroy]

    # GET /subtitles
    def index
        @titles = Subtitle.group(:title)
    end

    # GET /subtitles/1
    def show
        @sub = Subtitle.all
        @subtitles = category_subtitles.paginate(page: params[:page], per_page: 12).order('word_rank DESC')
        @wordgroups = category_filter(WordGroupResult).where(title: category_title)
        @themes = category_filter(ThemeGroupResult).where(title: category_title)
        @predicates = category_filter(PredicateGroupResult).where(title: category_title)
        @submodalities = category_filter(SubmodalitiesGroupResult).where(title: category_title)
    end


  private


    def category_filter(model)
        Subtitle.where(id: model.pluck(:subtitle_id)).order('counter DESC').paginate(page: params[:page], per_page: 12)
    end

    def category_title
        @title = Subtitle.find(params[:id]).title
    end

    # find all categorys matching id
    def category_subtitles
        subtitle  = Subtitle.where(category_id: params[:category], title: category_title)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_subtitle
      @subtitle = Subtitle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subtitle_params
      params.require(:subtitle).permit(:word, :title, :counter)
    end
end
