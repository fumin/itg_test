class MyController < ApplicationController
  def some_method
    SomeModel.first.update_column :a_column, false
    Thread.new{ AnotherModel.do_something  }
    render text: 'ok'
  end
end
