# user = User.new(name:'kazuto',email: 'kazuto@gmail.com', password: '000000')
# user.save!
# user = User.find(1).id
# 100.times do |n|
#   draft_learn=DraftLearn.new({id: nil, title: "test#{n}", content: "test#{n}", subject: "", time: rand(6), user_id: user, created_at: nil, updated_at: nil})
#   subject=rand(5)
#   case subject
#     when 1
#       draft_learn.subject="プログラミング"
#     when 2
#       draft_learn.subject="英語"
#     when 3
#       draft_learn.subject="資格"
#     when 4
#       draft_learn.subject="その他"
#   end
#   draft_learn.save
#   draft_learn.created_at=Date.today-rand(365).days
#   draft_learn.save
# end
# puts "OK"

user = User.find(1).id
(1..DraftLearn.all.size).each do |n|
  draft_learn=DraftLearn.find(n)
  learn=Learn.new({id:n, title: "test#{n}", content: "test#{n}", subject: draft_learn.subject, time: rand(6), user_id: user, draft_learn_id:draft_learn.id,created_at: draft_learn.created_at, updated_at: nil})
  learn.save
  # learn.created_at=Date.today-rand(365).days
  # learn.save
end

# (1..Learn.all.size).each do |n|
#   Learn.find(n).destroy
# end

puts "OK"







# Date.today - rand(365).days

# user.image.attach(
#   io:File.open('./storage/images/_h21AB7G.png'),
#   filename: '_h21AB7G.png',
#   content_type: 'application/png'
# )

# # storage/images/_h21AB7G.png
# # /Users/kazuto/projects/Rails/Done/Done_api/storage/images/_h21AB7G.png
