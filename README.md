# itg_test - simple integration test framework
## Description
For Rails apps that are too complicated to be tested with the
builtin integration test, such as apps that spawn threads
that update the same database table.  
For example, we have this piece of code in our app
```
1  class MyController < ApplicationController
2    def some_method
3      SomeModel.find(id).update_column :a_column, false
4      Thread.new{ AnotherModel.do_something }
5    end
6  end
7
8  class AnotherModel < ActiveRecord::Base
9    def do_something
10     SomeModel.find(id).update_column :a_column, true
11   end
12 end
13
14 # Rails built-in integration test
15 class MyIntegrationTest < ActionDispatch::IntegrationTest
16   test '' do
17     get '/some_method'
18     assert_response :success
19     sleep(1) # wait for the thread in MyController to finish
20     assert SomeModel.find(id).a_column # assertion fails with a false value :(
21   end
22 end
```
Our integration test will fail in line 20 no matter how long we waited for
in line 19, because the spawned thread can never update the column in line 10.
The reason is because Rails essentially allows only one thread to access the database
at a time when running integration tests.
itg_test overcomes this obstacle by simply starting a server
and a client in separate processes.  

## Installation
Add `gem 'itg_test'` in your app's Gemfile, and run `bundle install`

## Usage
* Create a `itg` folder under Rail's default test folder by running
  `mkdir test/itg`.
  Now your `test` directory structure should look something like  

  `$ls test`  
  
  `fixtures  functional  integration  itg  test_helper.rb  unit`

* Write integration tests as you would with Rail's default
  integration test framework. Remember to place them under
  the `itg` folder instead of Rail's default `integration` folder.  
  For example, create `test/itg/your_app_test.rb` with the following contents
  ```
  require 'itg_test'

  class YourAppTest < ItgTest::TestCase
    test 'a complete test' do
      get '/peanuts'
      assert_select 'h3 p:nth-child(3)', 'very yummy'
      ...
    end
  end
  ```
* Run your itg_test tests with `rake test:itg`
* itg_test supports the common Rails integration test helpers,
  including `assert_equal`, `assert_difference` and `assert_select` etc.
* You might find the following script that runs all
  Rails and itg_test tests in one shot handy
  ```
  desc "all tests"
  task 'test:all' => %w[test test:itg] do
  end
  ```

## CONTRIBUTORS:

* awaw fumin (@awawfumin)

## LICENSE:

Apache License 2.0

Copyright (c) 2011-2012, Cardinal Blue

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
