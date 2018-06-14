class SongsController < ApplicationController
#  before_action :set_song
#  skip_before_action :set_song, only: [:new, :create]

  PAGE_SIZE = 10

  def ng
    @base_url = "/songs/ng"
    render :index
  end

  # GET /songs
  # GET /songs.json
  def index
    @page = (params[:page] || 0).to_i
    @sort = (params[:sort] || "title ASC")
    if params[:keywords].present?
      @keywords = params[:keywords]
      song_search_term = SongSearchTerm.new(@keywords)
      @songs = Song.where(
      "similarity(title, ?) > 0.7 OR similarity(artist, ?) > 0.7", @keywords, @keywords).
      order(@sort).
      offset(PAGE_SIZE * @page).limit(PAGE_SIZE)
      count = Song.where("similarity(title, ?) > 0.7 OR similarity(artist, ?) > 0.7", @keywords, @keywords).limit(150).count
    else
      @songs = []
      count = 0
    end
    @pages = count < 149 ? count / PAGE_SIZE : "15+"


    respond_to do |format|
      format.html {
        redirect_to songs_ng_path
      }
      format.json {
        render json: { songs: @songs, page: @page, sort: @sort, pages: @pages }
      }
    end
  end

  # GET /songs/1
  # GET /songs/1.json
  def show
    song = Song.find(params[:id])
    taggings = Tagging.where(song_id: song.id)
    tags = []
    votes = []
    upvoted_tags = []
    downvoted_tags = []
    unvoted_tags = []

    unless taggings.empty?
      taggings.each do |tagging|
        tag = Tag.find(tagging.tag_id)
        tags << { tag: tag, score: tagging.votes.sum(:vote) }
        if current_user
          vote = Vote.find_by(voteable_type: "Tagging", voteable_id: tagging.id, user_id: current_user.id)
        end
        if vote && vote.vote > 0
          votes << vote
          upvoted_tags << { tag: tag, score: tagging.votes.sum(:vote) }
        elsif vote && vote.vote < 0
          votes << vote
          downvoted_tags << { tag: tag, score: tagging.votes.sum(:vote) }
        else
          unvoted_tags << { tag: tag, score: tagging.votes.sum(:vote) }
        end
      end
    end

    upvoted_tags.sort_by!{|k| k["score"]}
    downvoted_tags.sort_by!{|k| k["score"]}
    unvoted_tags.sort_by!{|k| k["score"]}

    respond_to do |format|
      format.html { redirect_to "/"}
      format.json { render json: { song: song, tags: tags, votes: votes,
        upvoted_tags: upvoted_tags,  downvoted_tags: downvoted_tags, unvoted_tags: unvoted_tags} }
    end
  end

  # GET /songs/new
  def new
    @song = Song.new
  end

  # GET /songs/1/edit
  def edit
  end

  # POST /songs
  # POST /songs.json
  def create
  #  @song = Song.new(song_params)
  #  @song.added_by = User.find(current_user.id)
  #  respond_to do |format|
  #    if @song.save
  #      format.html { redirect_to "/", notice: 'Song was successfully created.' }
  #      format.json { render :show, status: :created, location: @song }
  #    else
  #      format.html { render :new }
  #      format.json { render json: @song.errors, status: :unprocessable_entity }
  #    end
  #  end
  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
  #  @song = Song.find(params[:id])
  #  respond_to do |format|
  #    if @song.update(song_params)
  #      format.html { redirect_to @song, notice: 'Song was successfully updated.' }
  #      format.json { render :show, status: :ok, location: @song }
  #    else
  #      format.html { render :edit }
  #      format.json { render json: @song.errors, status: :unprocessable_entity }
  #    end
  #  end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
  #  @song = Song.find(params[:id])
  #  @song.destroy
  #  respond_to do |format|
  #    format.html { redirect_to songs_url, notice: 'Song was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def song_params
      params.require(:song).permit(:title, :artist)
    end
end
