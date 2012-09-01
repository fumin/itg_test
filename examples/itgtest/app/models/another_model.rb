class AnotherModel < ActiveRecord::Base
  attr_accessible :qq
  
  def do_something
    SomeModel.first.update_column :a_column, true
  end
end
