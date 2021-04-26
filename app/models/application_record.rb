class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  def hellow
    puts "ss"
  end
end
