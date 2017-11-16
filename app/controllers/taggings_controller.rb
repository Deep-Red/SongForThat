class TaggingsController < ApplicationController
#  before_action :set_tagging, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @tagging = Tagging.new
  end

  def create
    song = Song.find(tagging_params[:song])
    tag = Tag.find(tagging_params[:tag])

    # Borrowed from SongsController#show
    taggings = Tagging.where(song_id: song.id)
    tags = []
    taggings.each do |tagging|
      tags << Tag.find(tagging.tag_id)
    end

    category = tagging_params[:category]
    @tagging = Tagging.new(song: song, tag: tag, category: category)
    @tagging.created_by = User.find(current_user.id)
    respond_to do |format|
      if @tagging.save
        format.html { redirect_to "/", notice: "#{@tagging.song.title} successfully tagged as #{@tagging.tag.name}." }
        format.json { render json: { song: song, tag: tag } }#render "/songs/#{song.id}.json" }
      else
        format.html { render :new }
        format.json { render json: @tagging.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @tagging = Tagging.find(tagging_params)
    @song = @tagging.song
    respond_to do |format|
      if @tagging.update(tagging_params)
        format.html { redirect_to @song, notice: "Tag #{@tagging.tag.name} successfully added to #{@tagging.song.title}." }
        format.json { render :show, status: :ok, location: @song }
      else
        format.html { render :edit }
        format.json { render json: @tagging.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  private

  def set_tagging
    @tagging = Tagging.find(params[:id])
  end

  def tagging_params
    params.require(:tagging).permit(
      :category,
      :song,
      :tag
    )
  end

end
