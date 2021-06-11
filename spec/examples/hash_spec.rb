require 'rails_helper'

RSpec.describe Hash do
  subject {{foo:7}}
  it {is_expected.to have_key(:foo)}
  it {is_expected.not_to have_key(:d)}
end

Persion=Struct.new(:name,:age)
RSpec.describe Persion.new("Jim",32) do
  it {is_expected.to have_attributes(name:"Jim")}
  it {is_expected.to have_attributes(name:a_string_starting_with("J"))}
  it {is_expected.to have_attributes(age:32)}
  it {is_expected.to have_attributes(age:(a_value > 30))}
  it { is_expected.to have_attributes(:name => a_string_starting_with("J"), :age => (a_value > 30) ) }
  it { is_expected.not_to have_attributes(:name => "Bob") }
  it { is_expected.not_to have_attributes(:age => 10) }
  it { is_expected.not_to have_attributes(:age => (a_value < 30) ) }
end

RSpec.describe a:7,b:5 do
  it {is_expected.to include(:a)}
  it {is_expected.to include(:a,:b)}
  it { is_expected.to include(:a => 7) }
  it { is_expected.to include(:b => 5, :a => 7) }
  it { is_expected.not_to include(:c) }
  it { is_expected.not_to include(:c, :d) }
  it { is_expected.not_to include(:d => 2) }
  it { is_expected.not_to include(:a => 5) }
end
