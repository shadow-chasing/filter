class SubtitlesController < ApplicationController
  before_action :set_subtitle, only: [:edit, :update, :destroy]

    # GET /subtitles
    # GET /subtitles.json
    def index
        @titles = Subtitle.group(:title)
    end

    # GET /subtitles/1
    # GET /subtitles/1.json
    def show
        @subtitles = category_subtitles.paginate(page: params[:page], per_page: 12).order('counter DESC')
        @wordgroups = category_filter(WordGroupResult).where(title: category_title)
        @filters = category_filter(FilterGroupResult).where(title: category_title)
        @predicates = category_filter(PredicateResult).where(title: category_title)
    end

    # GET /subtitles/new
    def new
        @subtitle = Subtitle.new
    end

    # GET /subtitles/1/edit
    def edit
    end

    # POST /subtitles
    def create
        @subtitle = Subtitle.new(subtitle_params)

        respond_to do |format|
        if @subtitle.save
            format.html { redirect_to @subtitle, notice: 'Subtitle was successfully created.' }
        else
            format.html { render :new }
        end
        end
    end

    # PATCH/PUT /subtitles/1
    def update
        respond_to do |format|
        if @subtitle.update(subtitle_params)
            format.html { redirect_to @subtitle, notice: 'Subtitle was successfully updated.' }
        else
            format.html { render :edit }
        end
        end
    end

    # DELETE /subtitles/1
    def destroy
        @subtitle.destroy
        respond_to do |format|
        format.html { redirect_to subtitles_url, notice: 'Subtitle was successfully destroyed.' }
        end
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
