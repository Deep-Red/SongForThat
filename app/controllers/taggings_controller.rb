class TaggingsController < ApplicationController
  before_action :set_tagging, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @tagging = Tagging.new
  end

  def create
  end

  def destroy
  end

  private

  def set_tagging
    @tagging = Tagging.find(params[:song, :tag, :category])
  end

  def tagging_params
    params.require(:tagging).permit(:song, :tag, :category, :user)
  end

end
