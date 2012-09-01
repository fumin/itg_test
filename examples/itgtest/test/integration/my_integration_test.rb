require 'test_helper'

class MyIntegrationTest < ActionDispatch::IntegrationTest
  test 'will fail' do
    get '/some_method'
    assert_response :success
    sleep(3)
    assert_equal true, SomeModel.first.a_column
  end
end
