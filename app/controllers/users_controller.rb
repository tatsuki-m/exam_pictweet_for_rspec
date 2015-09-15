class UsersController < ApplicationController

  def show
  @nickname = current_user.nickname
  @tweets = current_user.tweets.page(params[:page]).per(5).order('created_at DESC')
  @tweets_count = current_user.count_tweets
  end
end
