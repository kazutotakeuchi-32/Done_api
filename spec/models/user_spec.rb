require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  before(:example) do
    @user = "kazuto"
  end
  # before(:context) do
  #   ""
  # end

  it "それ自体と等しい" do
    expect(@user).to be(@user)
  end

#   it "is a new widget" do
#     @user
#    user= User.new
#    expect(user).to be_a_new(User)
#  end

#  it "is a new String" do
#    na=Na.new("na",1)
#    p na
#    # expect(na).to be_a_new(Na)
#  end

  # it "そもそもユーザが存在しない" do
  #   expect(User.count).to(eq 0)
  # end
end
