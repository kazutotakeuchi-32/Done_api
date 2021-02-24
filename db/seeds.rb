user = User.new(name:'kazuto',email: 'kazutotakeuchi32@gmail.com', password: '000000')
user.save!
user.image.attach(
  io:File.open('/Users/kazuto/projects/Rails/Done/Done_api/storage/images/_h21AB7G.png'),
  filename: '_h21AB7G.png',
  content_type: 'application/png'
)
# storage/images/_h21AB7G.png
# /Users/kazuto/projects/Rails/Done/Done_api/storage/images/_h21AB7G.png
