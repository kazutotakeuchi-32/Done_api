class DraftLearn < ApplicationRecord
  belongs_to :user
  def self.get_draft_learn_data(type,year,month,day)
    from=Time.now.ago(6.days).beginning_of_day
    to=Time.now.end_of_day
    case type
      when "year"
        from = Time.new(year)
        to   = from.end_of_year
      when "6months"
        from = Time.new(year,month)
        to   = from.since(5.month).end_of_month
      when "3months"
        from = Time.new(year,month)
        to   = from.since(2.month).end_of_month
        # to = Time.new(year,month.to_i+2).end_of_month
      when "month"
        from = Time.new(year,month)
        to   = from.end_of_month
      when "week"
        from = Time.new(year,month,day)
        to = from.since(6.days)
        puts "from:#{from}"
        puts  "to:#{to}"
      when "day"
        from = Time.new(year,month,day)
        to =   from.end_of_day
    end
    return from,to
  end


  def self.aggregation_data(type,from,to,year,month,day,learns)
    output=[]
    case type
      when "year"
        (from.month..to.month).each do |m|
          sum=0
          sum_days=learns.where("created_at >= ? and created_at <= ?",Time.new(year,m),Time.new(year,m).end_of_month)
          sum_days.each do |sum_day|
            sum+=sum_day.time
          end
          output.push({label:"#{m}月",data:sum})
        end
      when "3months","6months"
        if from.month > to.month
          (from.month..12).each do |m|
            sum=0
            sum_days=learns.where("created_at >= ? and created_at <= ?",Time.new(year,m),Time.new(year,m).end_of_month)
            sum_days.each do |sum_day|
              sum+=sum_day.time
            end
            output.push({label:"#{m}月",data:sum})
          end
          (1..to.month).each do |m|
            sum=0
            sum_days=learns.where("created_at >= ? and created_at <= ?",Time.new(to.year,m),Time.new(to.year,m).end_of_month)
            sum_days.each do |sum_day|
              sum+=sum_day.time
            end
            output.push(m==1? {label:" #{to.year}年#{m}月",data:sum}:{label:"#{m}月",data:sum})
          end
        else
          (from.month..to.month).each do |m|
            sum=0
            sum_days=learns.where("created_at >= ? and created_at <= ?",Time.new(year,m),Time.new(year,m).end_of_month)
            sum_days.each do |sum_day|
              sum+=sum_day.time
            end
            output.push({label:"#{m}月",data:sum})
          end
        end
      else
        if from.day > to.day
          (from.day..from.end_of_month.day).each do |d|
            sum=0
            puts year
            puts month
            sum_days=learns.where("created_at >= ? and created_at <= ?",Time.new(year,month,d),Time.new(year,month,d).end_of_day)
            sum_days.each do |sum_day|
              sum+=sum_day.time
            end
            output.push({label:"#{month}月#{d}日",data:sum})
          end
          (to.beginning_of_month.day..to.day).each do |d|
            sum=0
            puts year
            puts month
            sum_days=learns.where("created_at >= ? and created_at <= ?",Time.new(year,to.month,d),Time.new(year,to.month,d).end_of_day)
            sum_days.each do |sum_day|
              sum+=sum_day.time
            end
            output.push({label:"#{to.month}月#{d}日",data:sum})
          end
        else
          (from.day..to.day).each do |d|
            sum=0
            puts year
            puts month
            sum_days=learns.where("created_at >= ? and created_at <= ?",Time.new(year,month,d),Time.new(year,month,d).end_of_day)
            sum_days.each do |sum_day|
              sum+=sum_day.time
            end
            output.push({label:"#{month}月#{d}日",data:sum})
          end
        end
      end
    return output
  end
end
