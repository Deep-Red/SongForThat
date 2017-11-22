class UsersController < ApplicationController

  def show
      @user = current_user
      @tag_total = current_user.tags.count
      @tagging_total = current_user.taggings.count
      @votes_total = Vote.where(user: current_user).count
  end

private

  def tag_params
    params.require.permit(:id)
  end

end
