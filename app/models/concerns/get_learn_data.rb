module GetLearnData
  extend ActiveSupport::Concern
  included do
    scope :date_range,->(from,to){where("created_at >= ? and created_at <= ?",from,to)}
    validates :title,:content,:subject,:time,presence: true
    def self.get_start_and_end_time(type,year,month,day)
      from=Time.now.ago(6.days).beginning_of_day
      to=Time.now.end_of_day
      case type
        when "year"
          from = Time.new(year,month  )
          to = from.since(11.month).end_of_month
          # to = from.since(11.month)
          #  to=from.since(1.year)
          # to   = from.end_of_year
          # Time.new.since(11.month)
        when "6months"
          from = Time.new(year,month)
          to   = from.since(5.month).end_of_month
        when "3months"
          from = Time.new(year,month)
          to   = from.since(2.month).end_of_month
          # to = Time.new(year,month.to_i+2).end_of_month
        when "month"
          if day.to_i== 1
            # p Time.new(year,month,day) > Time.now.ago(1.month)
            if Time.new(year,month) > Time.now.ago(1.month)
              to   =  Time.new(year,month).ago(1.days).end_of_day
              from =  to.ago(1.month).since(1.days).beginning_of_day
            else
              from = Time.new(year,month)
              to   = from.end_of_month
              # from = Time.new(year,month)
              # to   = from.end_of_month
            end
            # from = Time.new(year,month)
            # to   = from.end_of_month
          else
            if Time.new(year,month) > Time.now.ago(1.month)
              to   =  Time.new(year,month,day).end_of_day
              from =  to.ago(1.month).since(1.days).beginning_of_day
            else
              from = Time.new(year,month,day)
              to = from.since(1.month).ago(1.days).end_of_day
            end

          end

        when "week"
          if Time.new(year,month,day) < Time.now.ago(6.days).beginning_of_day
            from = Time.new(year,month,day)
            to = from.since(6.days).end_of_day
          else
            to    = Time.new(year,month,day).end_of_day
            from  = to.ago(6.days).beginning_of_day
          end
          # Time.new(year,month,day)
        when "day"
          from = Time.new(year,month,day)
          to =   from.end_of_day
      end
      return from,to
    end
    def self.aggregation_data(type,from,to,year,month,day,learns)
      output=[]
      case type
        # when "year"
        #   (from.month..to.month).each do |m|
        #     sum=0
        #     sum_days=learns.date_range(
        #       Time.new(year,m),
        #       Time.new(year,m).end_of_month
        #     )
        #     sum_days.each do |sum_day|
        #       sum+=sum_day.time
        #     end
        #     output.push({label:"#{m}月",data:sum})
        #   end
        when "year","3months","6months"
          if from.month > to.month
            (from.month..12).each do |m|
              sum=0
              sum_days=learns.date_range(
                Time.new(year,m),
                Time.new(year,m).end_of_month
              )
              sum_days.each do |sum_day|
                sum+=sum_day.time
              end
              output.push({label:"#{m}月",data:sum})
            end
            (1..to.month).each do |m|
              sum=0
              sum_days=learns.date_range(
                Time.new(to.year,m),
                Time.new(to.year,m).end_of_month
              )
              sum_days.each do |sum_day|
                sum+=sum_day.time
              end
              output.push(m==1? {label:" #{to.year}年#{m}月",data:sum}:{label:"#{m}月",data:sum})
            end
          else
            (from.month..to.month).each do |m|
              sum=0
              sum_days=learns.date_range(
                Time.new(year,m),
                Time.new(year,m).end_of_month
              )
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
              sum_days=learns.date_range(
                Time.new(year,month,d),
                Time.new(year,month,d).end_of_day
              )
              p sum
              sum_days.each do |sum_day|
                sum+=sum_day.time
              end

             month = from.month if from.month != month.to_i
              output.push({label:"#{month}月#{d}日",data:sum})
            end
            (to.beginning_of_month.day..to.day).each.with_index(1) do |d,i|
              sum=0
              year = to.year if  year.to_i != to.year
              sum_days=learns.date_range(
                Time.new(year,to.month,d),
                Time.new(year,to.month,d).end_of_day
              )
              Time.new(year,to.month,d)
              sum_days.each do |sum_day|
                sum+=sum_day.time
              end
              output.push(
                from.year != to.year && i == 1 ?
                  {label:"#{to.year}年#{to.month}月#{d}日",data:sum}
                  :
                  {label:"#{to.month}月#{d}日",data:sum}
              )
            end
          else
           (from.day..to.day).each do |d|
              sum=0
              sum_days=learns.date_range(
                Time.new(year,month,d),
                Time.new(year,month,d).end_of_day
              )
              sum_days.each do |sum_day|
                sum+=sum_day.time
              end
              month = from.month if from.month != month.to_i
              output.push({label:"#{month}月#{d}日",data:sum})
            end
          end
        end
      return output
    end
  end
end
