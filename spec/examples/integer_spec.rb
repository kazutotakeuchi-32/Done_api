require 'rails_helper'

# def sum(a,b)
#   return a+b
# end

# RSpec.describe "a integer" do
#   it "数字が等しい" do
#     expect(5).to eq(5)
#   end

#   it "1+1は２" do
#     expect(sum(3,6)).to eq 9
#   end

#   it "10は真である" do
#     expect(10).to be 10
#   end

#   it "7は0ではない"do
#     expect(7).not_to be_zero
#   end
#   it "0は0である" do
#     expect(0).to be_zero
#   end
#   it "7は真である"do
#     expect(7).to be_truthy
#   end
#   it "7は偽りではない" do
#     expect(7).not_to be_falsey
#   end

#   it "7はnilではない" do
#     expect(7).not_to be_nil
#   end

#   it "nilはnilである" do
#     expect(nil).to be_nil
#   end
#   specify { expect(nil).to be_falsey }
#   specify { expect(false).to be_falsey}
#   specify { expect(1).not_to be_nil }

# end

# RSpec.describe 18 do
#   it { is_expected.to be < 20 }
#   it { is_expected.to be == 18 }
#   it { is_expected.to be > 10 }
#   it { is_expected.not_to be ==20}
#   it {is_expected.not_to be < 15}
#   it {is_expected.not_to be == "a"}
# end

# module MyModule; end

# class Float
#   include MyModule
# end

# RSpec.describe 17.0 do
#   it {is_expected.to be_kind_of(Float)}
#   it {is_expected.to be_kind_of(Float)}

#   it {is_expected.to be_kind_of(Numeric)}
#   it { is_expected.to be_a_kind_of(Numeric) }
#   it { is_expected.to be_an(Numeric) }

#   it { is_expected.to be_kind_of(MyModule) }
#   it { is_expected.to be_a_kind_of(MyModule) }
#   it { is_expected.to be_a(MyModule) }

#   it { is_expected.not_to be_kind_of(String) }
#   it { is_expected.not_to be_a_kind_of(String) }
#   it { is_expected.not_to be_a(String) }
# end

# RSpec.describe 27.5 do
#   it {is_expected.to be_within(0.5).of(27.9)}
#   it {is_expected.to be_within(0.5).of(28.0)}
#   it {is_expected.to be_within(0.5).of(27.0)}
#   it {is_expected.not_to be_within(0.5).of(26.0)}
# end

RSpec.describe (1..10) do
  it {is_expected.to cover(4)}
  it {is_expected.to cover(1,5,6,7,4)}
  it {is_expected.not_to cover(111,301,11)}

end

# class Counter
#   class << self
#     def increment
#       @count ||= 0
#       @count+=1
#     end
#     def count
#       @count ||=0
#     end
#   end
# end

# RSpec.describe Counter,"#increment" do
  # it "should increment the count by 2" do
  #   expect{Counter.increment}.to change{Counter.count}.from(0).to(1)
  # end
  # it "should not increment the count by 1 (using not_to)" do
  #   expect { Counter.increment }.not_to change { Counter.count }
  # end
  # it "should not increment the count by 1 (using to_not)" do
  #   expect { Counter.increment }.not_to change { Counter.count }
  # end

# end


# class Human
#   attr_accessor :name,:age
#   def initialize(name)
#       self.name = name
#       self.age =100
#       p self.age
#       # @name = name
#   end
#   def myname()
#     puts "my name is #{self.name}"
#   end
# end
