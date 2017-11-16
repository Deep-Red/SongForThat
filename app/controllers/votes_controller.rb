class VotesController < ApplicationController
  def upvote
    @voteable = find_voteable
    @vote = current_user.votes.find_or_create_by(voteable: @voteable)
    @vote.vote = 1
    @vote.save
  end

  def downvote
    @voteable = find_voteable
    @vote = current_user.votes.build
    @vote.vote = -1
    @vote.save
end
