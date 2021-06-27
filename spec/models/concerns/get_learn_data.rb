require 'rails_helper'
RSpec.describe   type: :model do
  create_spec_table :get_learn_data_tests do |t|
    t.string  :title,null: false
    t.string  :content,null: false
    t.string  :subject,null: false
    t.integer :time,null: false
    t.integer :user_id,null:false
    t.timestamps
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
          GetLearnDataTest.all.each{|s|puts "#{s.title}\n#{s.content}"}
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
      before  do
        365.times do |n|
          get_learn_data_test=GetLearnDataTest.new({id: nil, title: "test#{n}", content: "content#{n}", subject: "", time: 1, user_id: 1, created_at: nil, updated_at: nil})
          subject=rand(4)
          case subject
            when 0
              get_learn_data_test.subject="プログラミング"
            when 1
              get_learn_data_test.subject="英語"
            when 2
              get_learn_data_test.subject="資格"
            when 3
              get_learn_data_test.subject="その他"
          end
          get_learn_data_test.created_at=Time.new("2020","1","1").since(n.day)
          get_learn_data_test.save!
        end
      end
      let(:get_learn_datas){GetLearnDataTest.all}

      context "一年単位で集計する場合(type=years)" do
        context "2020/1/1~12/31" do
          it "12ヶ月分(月)のデータが存在する" do
            from,to = GetLearnDataTest.get_start_and_end_time("year","2020","1","1")
            output  = GetLearnDataTest.aggregation_data("year",from,to,"2020","1","1",get_learn_datas)
            expect(output.length).to eq 12
          end
          it "学習時間の合計は365時間である" do
            from,to = GetLearnDataTest.get_start_and_end_time("year","2020","1","1")
            output  = GetLearnDataTest.aggregation_data("year",from,to,"2020","1","1",get_learn_datas)
            total_time = output.sum { |o| o[:data]}
            expect(total_time).to eq 365
          end
        end
      end
      context "6ヶ月単位で集計する場合(type=6months)" do
        context "2020/1/1~6/30" do
          it "6ヶ月分(月)のデータが存在する" do
            from,to = GetLearnDataTest.get_start_and_end_time("6months","2020","1","1")
            output  = GetLearnDataTest.aggregation_data("6months",from,to,"2020","1","1",get_learn_datas)
            expect(output.length).to eq 6
          end
          it "学習時間の合計は182時間である" do
            from,to = GetLearnDataTest.get_start_and_end_time("6months","2020","1","1")
            output  = GetLearnDataTest.aggregation_data("6months",from,to,"2020","1","1",get_learn_datas)
            total_time = output.sum { |o| o[:data]}
            expect(total_time).to eq 182
          end
        end
      end
      context "3ヶ月単位で集計する場合(type=3months)" do
        context "2020/1/1~3/31" do
          it "3ヶ月分(月)のデータが存在する" do
            from,to = GetLearnDataTest.get_start_and_end_time("3months","2020","1","1")
            output  = GetLearnDataTest.aggregation_data("3months",from,to,"2020","1","1",get_learn_datas)
            expect(output.length).to eq 3
          end
          it "学習時間の合計は182時間である" do
            from,to = GetLearnDataTest.get_start_and_end_time("3months","2020","1","1")
            output  = GetLearnDataTest.aggregation_data("3months",from,to,"2020","1","1",get_learn_datas)
            total_time = output.sum { |o| o[:data]}
            expect(total_time).to eq 91
          end
        end
      end
      context "１ヶ月単位で集計する場合(type=month)" do
        context "2020/1/1~3/31" do
          it "31日分(日)のデータが存在する" do
            from,to = GetLearnDataTest.get_start_and_end_time("month","2020","1","1")
            output  = GetLearnDataTest.aggregation_data("month",from,to,"2020","1","1",get_learn_datas)
            expect(output.length).to eq 31
          end
          it "学習時間の合計は31時間である" do
            from,to = GetLearnDataTest.get_start_and_end_time("month","2020","1","1")
            output  = GetLearnDataTest.aggregation_data("month",from,to,"2020","1","1",get_learn_datas)
            total_time = output.sum { |o| o[:data]}
            expect(total_time).to eq 31
          end
        end
      end
      context "1週間単位で集計する場合"do
        context "2020/1/1~1/7" do
          it "7日分(日)のデータが存在する" do
            from,to = GetLearnDataTest.get_start_and_end_time("week","2020","1","1")
            output  = GetLearnDataTest.aggregation_data("week",from,to,"2020","1","1",get_learn_datas)
            expect(output.length).to eq 7
          end
          it "学習時間の合計は7時間である" do
            from,to = GetLearnDataTest.get_start_and_end_time("week","2020","1","1")
            output  = GetLearnDataTest.aggregation_data("week",from,to,"2020","1","1",get_learn_datas)
            total_time = output.sum { |o| o[:data]}
            expect(total_time).to eq 7
          end
        end
      end
      context "1日単位で集計する場合" do
        context "2020/1/1 00:00:00~23:59:59" do
          it "1日分(日)のデータが存在する" do
            from,to = GetLearnDataTest.get_start_and_end_time("day","2020","1","1")
            output  = GetLearnDataTest.aggregation_data("day",from,to,"2020","1","1",get_learn_datas)
            expect(output.length).to eq 1
          end
          it "学習時間の合計は1時間である" do
            from,to = GetLearnDataTest.get_start_and_end_time("day","2020","1","1")
            output  = GetLearnDataTest.aggregation_data("day",from,to,"2020","1","1",get_learn_datas)
            total_time = output.sum { |o| o[:data]}
            expect(total_time).to eq 1
          end
        end
      end
    end
  end
end
