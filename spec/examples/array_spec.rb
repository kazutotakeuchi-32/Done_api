require 'rails_helper'

class Na
  def initialize(name,age)
    @name=name
    @age=age
  end
end
na=Na.new("na",1)

RSpec.describe "a array" do
  it "配列は空である" do
    ary=[]
    expect(ary).to be_empty
  end
  it "配列は空ではない" do
    ary=[0,1]
    expect(ary).not_to be_empty
  end

  it "配列の要素は全て奇数である" do
    expect([1,3,3]).to all(be_odd)
  end

  it "配列の要素は全てStringクラスのインスタンスである" do
    expect(["ss","ss","tt"]).to all(be_an(String))
  end

  it "配列の要素は全てIntegerクラスのインスタンスである" do
    expect([0,10,11]).to all(be_an(Integer))
  end


  specify {expect(7).to be_truthy}

  specify {expect(nil).to be_falsey}

  specify{expect([0,1,3]).to contain_exactly(0,3,1)}

end

RSpec.describe [1,2,4] do
  it {is_expected.not_to be_empty}
end

RSpec.describe [0,1,2,3,4] do
  it {is_expected.to end_with 4}
  it {is_expected.to end_with 3,4}
  it {is_expected.not_to end_with 3}
  it {is_expected.not_to end_with 0,1,2,3,4,5}

  it {is_expected.to start_with 0}
  it {is_expected.to start_with(0,1)}
  it {is_expected.not_to start_with(2)}
  it {is_expected.not_to start_with(0,1,2,3,4,5)}
end

RSpec.describe [1,3,7] do
  it {is_expected.to include(1)}
  it {is_expected.to include(3)}
  it {is_expected.to include(7)}
  it {is_expected.to include(1,7)}
  it {is_expected.to include(a_kind_of(Integer))}
  it {is_expected.to include(be_odd.and be <10)}
  it {is_expected.to include(be_odd).at_least(:twice)}
  it {is_expected.not_to include(be_even)}
  it {is_expected.not_to include(17)}
end

def test(num,&proc)
  p yield[0]*100
end

result= test(10){[11].map{|d|d*10}}
