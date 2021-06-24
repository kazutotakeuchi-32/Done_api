require 'rails_helper'
RSpec.describe   type: :model do
  before(:all) do
    m = ActiveRecord::Migration.new
    m.verbose = false
    m.create_table :get_learn_data_tests do |t|
      t.string  :title,null: false
      t.string  :content,null: false
      t.string  :subject,null: false
      t.integer :time,null: false
      t.integer :user_id,null:false
      t.timestamps
    end
    100.times do |n|
      get_learn_data_test=GetLearnDataTest.new({id: nil, title: "test#{n}", content: "test#{n}", subject: "", time: rand(6), user_id: 1, created_at: nil, updated_at: nil})
      subject=rand(5)
      case subject
        when 1
          get_learn_data_test.subject="プログラミング"
        when 2
          get_learn_data_test.subject="英語"
        when 3
          get_learn_data_test.subject="資格"
        when 4
          get_learn_data_test.subject="その他"
      end
      get_learn_data_test.save
      get_learn_data_test.created_at=Date.today-rand(365).days
      get_learn_data_test.save
    end
  end
  after(:all) do
    m = ActiveRecord::Migration.new
    m.verbose = false
    m.drop_table :get_learn_data_tests
  end

  class GetLearnDataTest < ApplicationRecord
    include GetLearnData
  end
  let(:user){FactoryBot.create(:user)}
  let(:other_user){FactoryBot.create(:other)}

  describe "日付・集計アルゴリズム" do
    describe "get_start_and_end_time(集計する開始日、終了日を特定)" do
      context "一年単位で集計する場合(type=year)" do
        it "2020/4/１が開始日な場合は2020/4/1~2020/3/31まで" do
           from,to=GetLearnDataTest.get_start_and_end_time("year","2020","4","1")
           expect(from).to eq Time.new("2020","4","1")
           expect(to).to eq Time.new("2021","3","31").end_of_day
        end
        it "2021/6/10が開始日な場合は2021/6/1~2020/5/31まで" do
          from,to=GetLearnDataTest.get_start_and_end_time("year","2021","6","1")
          expect(from).to eq Time.new("2021","6","1")
          expect(to).to eq Time.new("2022","5","31").end_of_day
        end
      end
      context "6ヶ月単位で集計する場合(type=6months)" do
        it "2021/6/１が開始日な場合は2021/6/1~2022/11/30まで" do
          from,to=GetLearnDataTest.get_start_and_end_time("6months","2021","6","1")
          expect(from).to eq Time.new("2021","6","1")
          expect(to).to eq Time.new("2021","11","30").end_of_day
        end
        it "2021/1/23が開始日な場合は2021/1/1~2021/6/30まで" do
          from,to=GetLearnDataTest.get_start_and_end_time("6months","2021","1","23")
          expect(from).to eq Time.new("2021","1","1")
          expect(to).to eq Time.new("2021","6","30").end_of_day
        end
        it "2021/10/23が開始日な場合は2021/10/1~2022/3/31まで" do
          from,to=GetLearnDataTest.get_start_and_end_time("6months","2021","10","1")
          expect(from).to eq Time.new("2021","10","1")
          expect(to).to eq Time.new("2022","3","31").end_of_day
        end
      end
      context "3ヶ月単位で集計する場合(type=3months)" do
        it "2021/6/１が開始日な場合は2021/6/1~2022/8/31まで" do
          from,to=GetLearnDataTest.get_start_and_end_time("3months","2021","6","1")
          expect(from).to eq Time.new("2021","6","1")
          expect(to).to eq Time.new("2021","8","31").end_of_day
        end
        it "2021/1/23が開始日な場合は2021/1/1~2021/3/31まで" do
          from,to=GetLearnDataTest.get_start_and_end_time("3months","2021","1","23")
          expect(from).to eq Time.new("2021","1","1")
          expect(to).to eq Time.new("2021","3","31").end_of_day
        end
        it "2021/11/23が開始日な場合は2021/11/1~2022/1/31まで" do
          from,to=GetLearnDataTest.get_start_and_end_time("3months","2021","11","23")
          expect(from).to eq Time.new("2021","11","1")
          expect(to).to eq Time.new("2022","1","31").end_of_day
        end
      end
      context "１ヶ月単位で集計する場合(type=month)" do
        it "2021/4/１が開始日な場合は2021/4/1~2021/4/31まで" do
          from,to=GetLearnDataTest.get_start_and_end_time("month","2021","4","1")
          expect(from).to eq Time.new("2021","4","1")
          expect(to).to eq Time.new("2021","4","30").end_of_day
        end
        it "2021/4/15が開始日な場合は2021/4/15~2021/5/14まで" do
          from,to=GetLearnDataTest.get_start_and_end_time("month","2021","4","15")
          expect(from).to eq Time.new("2021","4","15")
          expect(to).to eq Time.new("2021","5","14").end_of_day
        end
        it "2020/12/14が開始日な場合は2021/12/14~2022/1/13まで" do
          from,to=GetLearnDataTest.get_start_and_end_time("month","2020","12","14")
          expect(from).to eq Time.new("2020","12","14")
          expect(to).to eq Time.new("2021","1","13").end_of_day
        end
        context "集計する開始日が現在日時から1ヶ月以内な場合" do
            it "2021/6/１が開始日な場合は2021/5/1~2021/5/31まで" do
              from,to=GetLearnDataTest.get_start_and_end_time("month","2021","6","1")
              expect(from).to eq Time.new("2021","5","1")
              expect(to).to eq Time.new("2021","5","31").end_of_day
            end
            it "2021/6/10が開始日な場合は2021/6/10~2021/5/11まで" do
              from,to=GetLearnDataTest.get_start_and_end_time("month","2021","6","10")
              expect(from).to eq Time.new("2021","5","11")
              expect(to).to eq Time.new("2021","6","10").end_of_day
            end
        end
      end
      context "1週間単位で集計する場合"do
        it "2021/4/１が開始日な場合は2021/4/1~2021/4/7" do
          from,to=GetLearnDataTest.get_start_and_end_time("week","2021","4","1")
          expect(from).to eq Time.new("2021","4","1")
          expect(to).to eq Time.new("2021","4","7").end_of_day
        end
        it "2021/3/28が開始日な場合は2021/3/28~2021/4/3" do
          from,to=GetLearnDataTest.get_start_and_end_time("week","2021","3","28")
          expect(from).to eq Time.new("2021","3","28")
          expect(to).to eq Time.new("2021","4","3").end_of_day
        end
        it "2020/12/30が開始日な場合は2020/12/30~2021/1/5" do
          from,to=GetLearnDataTest.get_start_and_end_time("week","2020","12","30")
          expect(from).to eq Time.new("2020","12","30")
          expect(to).to eq Time.new("2021","1","5").end_of_day
        end
        context "集計する開始日が現在日時から1週間以内な場合" do
          it "2021/6/20が開始日な場合は2021/6/13~2021/6/20まで" do
            from,to=GetLearnDataTest.get_start_and_end_time("week","2021","6","20")
            expect(from).to eq Time.new("2021","6","14")
            expect(to).to eq Time.new("2021","6","20").end_of_day
          end
        end
      end
      context "1日単位で集計する場合" do
        it "4月１に開始日な場合は4/1/00:00:00~23:59:59" do
          from,to=GetLearnDataTest.get_start_and_end_time("day","2021","4","1")
          expect(from).to eq Time.new("2021","4","1").beginning_of_day
          expect(to).to eq Time.new("2021","4","1").end_of_day
        end
      end
    end
    describe "aggregation_data(開始日~終了日を日付けごとに集計)" do
      before do
      end
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
