class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # アソシエーション
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,:confirmable
  include DeviseTokenAuth::Concerns::User
  has_one_attached :image
  has_many :draft_learns
  has_many :learns
  has_many :entries
  has_many :entry_to_rooms ,through: :entries, source: :room
  has_many :messages
  has_many :message_to_rooms ,through: :entries, source: :room
  has_many :likes
  has_many :learn_likes,through: :likes, source: :learn
  has_many :draft_learn_likes,through: :likes, source: :draft_learn
  has_many :relationships
  has_many :followings,through: :relationships, source: :follow
  has_many :reverse_of_relationships,class_name: 'Relationship',foreign_key: :follow_id
  has_many :followers,through: :reverse_of_relationships,source: :user
  has_many :reads
  has_many :sender_notifications, class_name: "Notification", foreign_key: "sender_id", dependent: :destroy
  has_many :receiver_notifications, class_name: "Notification", foreign_key: "receiver_id", dependent: :destroy

  # バリデーション
  VALID_EMAIL_REGEX = /\A[\w+-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i
  # validates :name,:email,:password,presence: true
  # validates :password, length: { minimum: 6 }
  validates :name ,presence: true
  validates :email,uniqueness: true,format:{with:VALID_EMAIL_REGEX}


  def follow(other_user)
    if self.id != other_user.id
      self.relationships.find_or_create_by(follow_id:other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id:other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end

  def mutual_following?(other_user)
     self.following?(other_user)? other_user.following?(self) : false
  end

  def likeing(other_user)
    if self.id != other_user.id
      self.relationships.find_or_create_by(follow_id:other_user.id)
    end
  end

  def unlike(other_user)
    learn_like=self.learn_likes.find_by(id:other_user.id)
    learn_likes.destroy if learn_likes
  end

  def combine_with_friends
    users=[self]+self.followings
    users.sort!{|a,b|a.id<=>b.id}
  end

  def image_url
    image.attached? ? url_for(image) : nil
  end

  def likeing_type(type,d)
    case type
      when  "DRAFTLEARN"
        likeing_contents=self.draft_learns.where(created_at:Time.new(d[0],d[1],d[2]).beginning_of_day..Time.new(d[0],d[1],d[2]).end_of_day)
        model={id:"draft_learn_id"}
      when  "LEARN"
        likeing_contents=self.learns.where(created_at:Time.new(d[0],d[1],d[2]).beginning_of_day..Time.new(d[0],d[1],d[2]).end_of_day)
        model={id:"learn_id"}
    end
    return likeing_contents,model
  end

  def unlike_type(type,other_user,d)
    case type
      when  "DRAFTLEARN"
        likeing_contents = self.draft_learn_likes.where(
          created_at:Time.new(d[0],d[1],d[2]).beginning_of_day..Time.new(d[0],d[1],d[2]).end_of_day,
          user_id:other_user.id
        )
        model={id:"draft_learn_id"}
      when  "LEARN"
        likeing_contents = self.learn_likes.where(
          created_at:Time.new(d[0],d[1],d[2]).beginning_of_day..Time.new(d[0],d[1],d[2]).end_of_day,
          user_id:other_user.id
        )
        model={id:"learn_id"}
    end
    return likeing_contents,model
  end

  def self.get_achievement_rate(dividend,divisor)
    return 0 if divisor<=0
    achievement_rate=(dividend/divisor.to_f)*100
    achievement_rate.round
  end

  def self.time_line(time_line,users)
    output=[]
    time_line.each do |time_line|
      draft,learn=time_line.sort{|a,b|a.user_id<=>b.user_id}.group_by{|d|d[:draft_learn_id]!=nil}.values
      strings1=[]
      if draft
        time = 0
        user_id= draft[0].user_id
        string1="#{draft[0].created_at.year}/#{draft[0].created_at.month}/#{draft[0].created_at.day}\n学習計画"
        i=1
        draft.each do |d|
          if user_id != d.user_id
            strings1.push(
            {
              user:users.find{|user|user.id==user_id},
              data:string1+"\n学習計画(時):#{time}",
              likes: d.likes,
              })
            string1="#{d.created_at.year}/#{d.created_at.month}/#{d.created_at.day}\n学習計画"
            time=0
            user_id=d.user_id
            i=1
          end
          string1+="\n#{i}.#{d.title}"
          time+=d.time
          i+=1
        end
        # strings1.push({user:users.find{|user|user.id==user_id}, data:string1+"\n学習計画(時):#{time}",likes:draft[draft.size-1].likes})
      end
      strings2=[]
      if learn
        time = 0
        user_id= learn[0].user_id
        date="#{learn[0].created_at.year}/#{learn[0].created_at.month}/#{learn[0].created_at.day}"
        string2="#{date}\n学習の振り返り"
        plan_time=nil
        i=1
        learn.each do |l|
          if user_id != l.user_id
            date="#{l.created_at.year}/#{l.created_at.month}/#{l.created_at.day}"
            plan_time=strings1.select{|s|s[:data].include?(date)&&s[:user][:id]==user_id}[0][:data].match(/学習計画\(時\):[0-9]*/)[0]
            # strings2.push({user:users.find{|user|user.id==user_id},data:string2+"\n#{plan_time}"+"\n学習完了（時）：#{time}"})
            strings2.push({user:users.find{|user|user.id==user_id},data:string2+"\n#{plan_time}"+"\n学習完了（時）：#{time}\n達成率(%)：#{self.get_achievement_rate(time,plan_time.to_s.match(/[0-9]+/)[0].to_i)}",likes:l.likes})
            string2="#{l.created_at.year}/#{l.created_at.month}/#{l.created_at.day}\n学習の振り返り"
            user_id=l.user_id
            time=0
            i=1
          end
          string2+="\n#{i}.#{l.title}"
          time+=l.time
          i+=1
        end
        plan_time=strings1.select{|s|s[:data].include?(date)&&s[:user][:id]==user_id}[0][:data].match(/学習計画\(時\):[0-9]*/)
        #strings2.push({user:users.find{|user|user.id==user_id},data:string2+"\n学習完了（時）：#{time}"})
        strings2.push({user:users.find{|user|user.id==user_id},data:string2+"\n#{plan_time}"+"\n学習完了（時）：#{time}\n達成率(%)：#{self.get_achievement_rate(time,plan_time.to_s.match(/[0-9]+/)[0].to_i)}",likes:learn[learn.size-1].likes})
      end
      output.push(strings1,strings2)
    end
    output=output.delete_if(&:empty?).flatten
    output
  end

end
