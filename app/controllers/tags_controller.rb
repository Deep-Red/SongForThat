class TagsController < ApplicationController
#  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  PAGE_SIZE = 15

  def ng
    @base_url = "/tags/ng"
    render :index
  end

  # GET /tags
  # GET /tags.json
  def index
    @page = (params[:page] || 0).to_i
    if params[:keywords].present?
      @keywords = params[:keywords]
      tag_search_term = TagSearchTerm.new(@keywords)
      @tags = Tag.where(
      tag_search_term.where_clause,
      tag_search_term.where_args).
      order(tag_search_term.order).
      offset(PAGE_SIZE * @page).limit(PAGE_SIZE)
    else
      @tags = []
    end
    respond_to do |format|
      format.html {}
      format.json {
        render json: { tags: @tags }
      }
    end
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
    @page = (params[:page] || 0).to_i
    tag = Tag.find(params[:id])
    taggings = Tagging.where(tag_id: tag.id).offset(PAGE_SIZE * @page).limit(PAGE_SIZE)
    songs = []
    taggings.each do |tagging|
      songs << Song.find(tagging.song_id)
    end
    respond_to do |format|
      format.html { redirect_to "/"}
      format.json { render json: { tag: tag, songs: songs } }
    end
  end

  # GET /tags/new
  def new
    @tag = Tag.new
  end

  # GET /tags/1/edit
  def edit
  end

  # POST /tags
  # POST /tags.json
  def create
    @tag = Tag.new(tag_params)
    @tag.added_by = User.find(current_user.id)
    @tag.name.downcase!
    respond_to do |format|
      if @tag.save
        format.html { redirect_to "/", notice: 'Tag was successfully created.' }
        format.json { render json: { tag: @tag } }
      else
        format.html { render :new }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tags/1
  # PATCH/PUT /tags/1.json
  def update
    @tag = Tag.find(params[:id])
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to @tag, notice: 'Tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    respond_to do |format|
      format.html { redirect_to tags_url, notice: 'Tag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = Tag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      params.require(:tag).permit(:name, :references, :page)
    end
end
