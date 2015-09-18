require "rails_helper"

describe TweetsController do
  shared_examples 'public access to tweets' do
    describe "GET #index" do
      before :each do
        @tweet = create(:tweet)
      end

      it "assigns the requested tweet to @tweet" do
        get :index
        expect(assigns(:tweets)).to match_array [@tweet]
      end

      it "renders the :index template" do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  shared_examples 'user access to tweets' do
    describe "GET #new" do
      it "renders the :new template" do
        get :new
        expect(response).to render_template :new
      end
    end

    describe "GET #edit" do
      before :each do
        @tweet = create(:tweet, user: @user)
      end

      it "assigns the requested tweet to @tweet" do
        get :edit, id: @tweet
        expect(assigns(:tweet)).to eq @tweet
      end

      it "renders the :edit template" do
        get :edit, id: @tweet
        expect(response).to render_template :edit
      end
    end

    describe "POST #create" do
      before :each do
        @attr = attributes_for(:tweet,
            text: "hogehoge",
            image: "http://hogehoge"
        )
      end

      it "save the new tweet in the database" do
        expect{
          post :create, user_id: @user, text: @attr[:text], image: @attr[:image]
        }.to change(Tweet, :count).by(1)
      end

      it "renders the :create template" do
        post :create, user_id: @user, text: @attr[:text], image: @attr[:image]
        expect(response).to render_template :create
      end
    end

    describe "PATCH #update" do
      before :each do
        @tweet = create(:tweet,
          user: @user,
          text: "hogehoge",
          image: "http://hogehoge")

        @another_user = create(:user)
        @different_tweet = create(:tweet, user: @another_user)

        @attr = attributes_for(:tweet,
              text: "hogehogehoge",
              image: "http://hogehogehoge"
        )
      end

      context "valid tweet" do
        it "changes the tweet's attributes" do
          patch :update, id: @tweet, text: @attr[:text], image: @attr[:image]
          @tweet.reload
          expect(@tweet.text).to eq("hogehogehoge")
          expect(@tweet.image).to eq("http://hogehogehoge")
        end

        it "renders the :update template" do
          patch :update, id: @tweet
          expect(response).to render_template :update
        end
      end

      context "invalid tweet" do
        it "does not change the contact's attributes" do
          patch :update, id: @different_tweet, text: @attr[:text], image: @attr[:image]
          @tweet.reload
          expect(@tweet.text).to eq("hogehoge")
          expect(@tweet.image).not_to eq("http://hogehogehoge")
        end

        it "renders the :update template" do
          patch :update, id: @tweet
          expect(response).to render_template :update
        end
      end
    end

    describe "DELETE #destory" do
      before :each do
        @tweet = create(:tweet, user: @user)
        @another_user = create(:user)
        @another_tweet = create(:tweet, user: @another_tweet)
      end
      context "valid tweet" do
        it "deletes the tweet" do
          expect{
            delete :destroy, id: @tweet
          }.to change(Tweet, :count).by(-1)
        end

        it "renders the :delete template" do
          delete :destroy, id: @tweet
          expect(response).to render_template :destroy
        end
      end

      context "invalid tweet" do
        it "doesn't delete the tweet" do
          expect{
            delete :destroy, id: @another_tweet
          }.to change(Tweet, :count).by(0)
        end
        it "renders teh :delete template" do
          delete :destroy, id: @tweet
          expect(response).to render_template :destroy
        end
      end
    end
  end

  shared_examples 'guest access to tweets' do
    before :each do
      @tweet = create(:tweet, user: @user)
    end

    describe "GET #new" do
      it "requires login" do
        get :new
        expect(response).to redirect_to root_url
      end
    end

    describe "GET #edit" do
      it "requires login" do
        get :new, id: @tweet
        expect(response).to redirect_to root_url
      end
    end

    describe "POST #create" do
      before :each do
        @attr = attributes_for(:tweet,
            text: "hogehoge",
            image: "http://hogehoge"
        )
      end

      it "requires login" do
        post :create, user_id: @user, text: @attr[:text], image: @attr[:image]
        expect(response).to redirect_to root_url
      end
    end

    describe "PATCH #update" do
      it "requires login" do
        patch :update, id: @tweet
        expect(response).to redirect_to root_url
      end
    end

    describe "DELETE #destory" do
      it "requires login" do
        delete :destroy, id: @tweet
        expect(response).to redirect_to root_url
      end
    end
  end

  describe 'user access' do
    before :each do
      @user = create(:user)
      set_user_session @user
    end

    it_behaves_like 'public access to tweets'
    it_behaves_like 'user access to tweets'
  end

  describe 'guest access' do

    it_behaves_like 'public access to tweets'
    it_behaves_like 'guest access to tweets'
  end
end