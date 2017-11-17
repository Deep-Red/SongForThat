class VotesController < ApplicationController
  def upvote

    @voteable = find_voteable
    @vote = Vote.find_or_create_by(voteable: @voteable, user_id: current_user.id)
    @vote.vote = 1
    @vote.save

    respond_to do |format|
      format.html { redirect_to "/"}
      format.json { render json: { tag: @voteable.tag } }
    end
  end

  def downvote
    @voteable = find_voteable
    @vote = Vote.find_or_create_by(voteable: @voteable, user_id: current_user.id)
    @vote.vote = -1
    @vote.save

    respond_to do |format|
      format.html { redirect_to "/" }
      format.json { render json: { tag: @voteable.tag } }
    end 
  end

  private

  def find_voteable
    params[:voteable_type].constantize.find_by(tag_id: params[:tag_id], song_id: params[:song_id])
  end

  def song_params
    params.require.permit(:tag_id, :voteable_type, :song_id)
  end
end
