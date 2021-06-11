require 'rails_helper'

RSpec.describe "a string" do

  it "それ自体と等しい" do
    string = "等しい"
    expect(string).to be(string)
    expect(string).to equal(string)
  end

  it "is not equal to another string of the same value" do
    expect("this string").not_to be("this string")
  end

  it "is not equal to another string of a different value" do
    expect("this string").not_to be("a different string")
  end

  it {is_expected.to include("str")}
  it {is_expected.to include("a","str","ng")}
  it {is_expected.to include(/a|str/).twice}
  it {is_expected.not_to include("foo")}
  it {is_expected.not_to include("foo","bar")}
  it {is_expected.to match(/str/)}
  it {is_expected.not_to match(/foo/)}

end

RSpec.describe "this string" do
  it {is_expected.to start_with "this"}
  it {is_expected.not_to start_with "that"}
end

RSpec.describe 'a' do
  it {is_expected.to be < "b"}
  it {is_expected.not_to be > "d"}
end

RSpec.describe "this string" do
  it {is_expected.to end_with "string"}
  it {is_expected.not_to end_with "strinp" }
end

RSpec.describe /foo/ do
  it {is_expected.to match("food")}
  it {is_expected.not_to match("drinks")}
end

# class Planet
#   attr_accessor :name
#   attr_reader :name
#   def initialize(name)
#     self.name=name
#   end
#   def inspect
#     "<Planet>#{self.name}"
#   end

# end

class Planet
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def inspect
    "<Planet: #{name}>"
  end

  def exist? # also works with exists?
    %w[Mercury Venus Earth Mars Jupiter Saturn Uranus Neptune].include?(name)
  end
end

RSpec.describe "Earth" do
  let(:earth) {Planet.new("Earth")}
  specify {expect(earth).to exist}
end
