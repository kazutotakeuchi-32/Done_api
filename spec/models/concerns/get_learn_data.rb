require 'rails_helper'
RSpec.describe  type: :model do
  class GetLearnDataTest < ApplicationRecord
    include GetLearnData
  end
  let(:user){FactoryBot.create(:user)}
  let(:other_user){FactoryBot.create(:other)}
  let(:draft_learn){FactoryBot.build(:draft_learn,user_id:user.id)}
  let(:learn){FactoryBot.build(:learn,user_id:user.id)}
  before do
  end
  describe "日付・集計アルゴリズム" do
    describe "get_draft_learn_data(集計する開始日、終了日を特定)" do
      context "一年単位で集計する場合(type=years)" do
        it "１月１日" do
        end
      end
      context "6ヶ月単位で集計する場合(type=6months)" do
        it "" do
        end
      end
      context "3ヶ月単位で集計する場合(type=3months)" do
        it "" do
        end
      end
      context "１ヶ月単位で集計する場合(type=month)" do
      end
      context "1週間単位で集計する場合"do
      end
      context "1日単位で集計する場合" do
      end
    end
    describe "aggregation_data(開始日~終了日を日付けごとに集計)" do
      context "一年単位で集計する場合(type=years)" do
        it "" do
        end
      end
      context "6ヶ月単位で集計する場合(type=6months)" do
        it "" do
        end
      end
      context "3ヶ月単位で集計する場合(type=3months)" do
        it "" do
        end
      end
      context "１ヶ月単位で集計する場合(type=month)" do
      end
      context "1週間単位で集計する場合"do
      end
      context "1日単位で集計する場合" do
      end
    end
  end

end
