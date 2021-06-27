FactoryBot.define do
  factory :user do
    name {"kazuto"}
    # provider {"email"}
    email {"kazuto@gmail.com"}
    # avatar {""}
    admin {false}
    password {"000000"}
    password_confirmation {"000000"}
  end

  factory :other, class: User  do
    name {"t.kazuto"}
    # provider {"email"}
    email {"kazuto@gmail.com"}
    # avatar {""}
    admin {false}
    password {"000000"}
    password_confirmation {"000000"}
    confirmed_at { Time.now }
  end

  factory :no_login_user, class: User  do
    name {"jun"}
    # provider {"email"}
    email {"toku@gmail.com"}
    # avatar {""}
    admin {false}
    password {"000000"}
    password_confirmation {"000000"}
    confirmed_at { Time.now }
  end

  factory :test_user1,class:User do
    name {"田村悠人"}
    # provider {"email"}
    email {"tamu@gmail.com"}
    # avatar {""}
    admin {false}
    password {"000000"}
    password_confirmation {"000000"}
    confirmed_at { Time.now }
  end

  factory :test_user2,class:User do
    name {"田村仁"}
    # provider {"email"}
    email {"tamutamu@gmail.com"}
    # avatar {""}
    admin {false}
    password {"000000"}
    password_confirmation {"000000"}
    confirmed_at { Time.now }
  end


  factory :test_user3,class:User do
    name {"鈴木龍弥"}
    # provider {"email"}
    email {"syuiti@gmail.com"}
    # avatar {""}
    admin {false}
    password {"000000"}
    password_confirmation {"000000"}
    confirmed_at { Time.now }
  end

  factory :test_user4,class:User do
    name {"鈴木純也"}
    # provider {"email"}
    email {"suzuki@gmail.com"}
    # avatar {""}
    admin {false}
    password {"000000"}
    password_confirmation {"000000"}
    confirmed_at { Time.now }
  end

  factory :test_user5,class:User do
    name {"鈴木"}
    # provider {"email"}
    email {"sumusumu@gmail.com"}
    # avatar {""}
    admin {false}
    password {"000000"}
    password_confirmation {"000000"}
    confirmed_at { Time.now }
  end

  factory :test_user6,class:User do
    name {"竹内和人"}
    # provider {"email"}
    email {"kazuto300@gmail.com"}
    # avatar {""}
    admin {false}
    password {"000000"}
    password_confirmation {"000000"}
    confirmed_at { Time.now }
  end

  factory :test_user7,class:User do
    name {"jun"}
    # provider {"email"}
    email {"junjun@gmail.com"}
    # avatar {""}
    admin {false}
    password {"000000"}
    password_confirmation {"000000"}
    confirmed_at { Time.now }
  end

  factory :test_user8,class:User do
    name {"ryo"}
    # provider {"email"}
    email {"ryo@gmail.com"}
    # avatar {""}
    admin {false}
    password {"000000"}
    password_confirmation {"000000"}
    confirmed_at { Time.now }
  end

  factory :test_user9,class:User do
    name {"yui"}
    # provider {"email"}
    email {"yuiyui@gmail.com"}
    # avatar {""}
    admin {false}
    password {"000000"}
    password_confirmation {"000000"}
    confirmed_at { Time.now }
  end

  factory :test_user10,class:User do
    name {"totuka"}
    # provider {"email"}
    email {"totuka@gmail.com"}
    # avatar {""}
    admin {false}
    password {"000000"}
    password_confirmation {"000000"}
    confirmed_at { Time.now }
  end



end
