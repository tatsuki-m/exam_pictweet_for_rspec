require "rails_helper"

describe UsersController do
  before :each do
    @user = create(:user)
    set_user_session @user
  end

  describe "GET #show" do
    it "assigns the requested nickname to @user'nickname" do
      get :show, id: @user
      expect(assigns(:nickname)).to eq @user.nickname
    end

    it "assigns the requested tweet to @tweets" do
      get :show, id: @user, page: 1
      expect(assigns(:tweets)).to eq @user.tweets
    end

    it "assigns the requested the number of tweets to @tweets_count" do
      create(:tweet, user: @user)
      get :show, id: @user
      expect(assigns(:tweets_count)).to eq @user.tweets.count
    end

    it "renders the :show template" do
      get :show, id: @user
      expect(response).to render_template :show
    end
  end
end