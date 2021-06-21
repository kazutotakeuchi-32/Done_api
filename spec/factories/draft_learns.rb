FactoryBot.define do
  factory :draft_learn do
    title{"Rubyの基礎文法を学ぶ"}
    content {"プロゲートでRubyをクリアする。"}
    subject {"プログラミング"}
    time {3}
    user_id {nil}
  end

end
