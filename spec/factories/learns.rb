FactoryBot.define do
  factory :learn do
    title{"Rubyの基礎文法を学ぶ"}
    content {"プロゲートでRubyをクリアする。"}
    subject {"プログラミング"}
    time {10}
    user_id {nil}
    draft_learn_id {nil}
  end
end
