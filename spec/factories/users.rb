FactoryBot.define do
  factory :user do
    name {"kazuto"}
    # provider {"email"}
    email {"kazutotakeuchi32@gmail.com"}
    # avatar {""}
    admin {false}
    password {"000000"}
    password_confirmation {"000000"}
  end

  factory :other, class: User  do
    name {"kazuto"}
    # provider {"email"}
    email {"kazutotakeuchi32@gmail.com"}
    # avatar {""}
    admin {false}
    password {"000000"}
    password_confirmation {"000000"}
    confirmed_at { Time.now }
  end

end
