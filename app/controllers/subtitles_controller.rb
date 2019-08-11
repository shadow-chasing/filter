class SubtitlesController < ApplicationController
  before_action :set_subtitle, only: [:edit, :update, :destroy]

  # GET /subtitles
  # GET /subtitles.json
  def index
    @titles = Subtitle.group(:title)


    #@predicates = PredicateResult.all.paginate(page: params[:page], per_page: 20)
    #@wordgroups = WordGroupResult.all.paginate(page: params[:page], per_page: 20)
    #@filters = FilterGroupResult.all.paginate(page: params[:page], per_page: 20)
end

  # GET /subtitles/1
  # GET /subtitles/1.json
  def show
      if params[:category]
        @subtitles = category_attributes.paginate(page: params[:page], per_page: 12).order('counter DESC')
        @wordgroups = Subtitle.where(id: WordGroupResult.pluck(:subtitle_id)).order('counter DESC').paginate(page: params[:page], per_page: 12)
        @filters = Subtitle.where(id: FilterGroupResult.pluck(:subtitle_id)).order('counter DESC').paginate(page: params[:page], per_page: 12)
        @predicates = Subtitle.where(id: PredicateResult.pluck(:subtitle_id)).order('counter DESC').paginate(page: params[:page], per_page: 12)
      else
        @title = Subtitle.find(params[:id])
        @subtitle = Subtitle.where(title: @title.title)
      end
  end

  # GET /subtitles/new
  def new
    @subtitle = Subtitle.new
  end

  # GET /subtitles/1/edit
  def edit
  end

  # POST /subtitles
  # POST /subtitles.json
  def create
    @subtitle = Subtitle.new(subtitle_params)

    respond_to do |format|
      if @subtitle.save
        format.html { redirect_to @subtitle, notice: 'Subtitle was successfully created.' }
        format.json { render :show, status: :created, location: @subtitle }
      else
        format.html { render :new }
        format.json { render json: @subtitle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subtitles/1
  # PATCH/PUT /subtitles/1.json
  def update
    respond_to do |format|
      if @subtitle.update(subtitle_params)
        format.html { redirect_to @subtitle, notice: 'Subtitle was successfully updated.' }
        format.json { render :show, status: :ok, location: @subtitle }
      else
        format.html { render :edit }
        format.json { render json: @subtitle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subtitles/1
  # DELETE /subtitles/1.json
  def destroy
    @subtitle.destroy
    respond_to do |format|
      format.html { redirect_to subtitles_url, notice: 'Subtitle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # find all categorys matching id
    def category_attributes
        subtitle  = Subtitle.where(category_id: params[:category])
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
