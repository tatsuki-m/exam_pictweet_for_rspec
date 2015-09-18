require "rails_helper"

describe User do
  it "is valid with less than 6 letters for nickname" do
    expect(build(:user)).to be_valid
  end

  it "is invalid with more than 6 letters for nickname" do
    user = build(:user, nickname: "hogehoge")
    user.valid?
    expect(user.errors[:nickname]).to include("is too long (maximum is 6 characters)")
  end

  it "is invalid without a nickname" do
    user = build(:user, nickname: nil)
    user.valid?
    expect(user.errors[:nickname]).to include("can't be blank")
  end

  it "is invalid without an emaild address" do
    user = build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "is invalid with a duplicate email address" do
    create(:user, email: "hogehoge@hoge.com")

    user = build(:user, email: "hogehoge@hoge.com")
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end

  it "returns the number of tweets" do
    user = create(:user)
    create(:tweet, user: user)
    expect(user.count_tweets).to eq 1
  end
end